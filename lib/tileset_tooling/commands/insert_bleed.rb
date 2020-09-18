# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'

require 'yaml'

# Command used to insert bleed around tiles
class ::TilesetTooling::Commands::InsertBleed < ::TilesetTooling::Commands::Command
  # Validates arguments/options and unpacks them
  def unpack!
    raise(::StandardError, 'Missing argument') unless @args.count == 1

    @image_path = @args.shift

    raise(::StandardError, "Could not find image '#{@image_path}'") unless ::File.exist?(@image_path)
  end

  # Runs this command
  def run
    @logger.info("Adding bleed to tiles in image file '#{@image_path}'")
    tileset = gather_image_information

    if tileset.margin.positive?
      modify_margin(tileset)
    else
      add_margin(tileset)
    end
  end

  private

  def modify_margin(tileset)
    ::MiniMagick::Tool::Convert.new do |convert|
      convert.background('none')
      convert << tileset.original_image_path

      tileset.for_each_tile do |tile|
        copy_rect(convert, tile.left, tile.top, 1, tile.width, tile.left, tile.top - 1) unless tile.top <= 0
        copy_rect(convert, tile.left, tile.bottom - 1, 1, tile.width, tile.left, tile.bottom) unless tile.bottom >= tileset.height
        copy_rect(convert, tile.left, tile.top, tile.height, 1, tile.left - 1, tile.top) unless tile.left <= 0
        copy_rect(convert, tile.right - 1, tile.top, tile.height, 1, tile.right, tile.top) unless tile.right >= tileset.width
      end

      convert.flatten
      convert << result_path
    end

    @logger.info("Result stored in '#{result_path}'")
  end

  def add_margin(tileset)
    nb_pixels_in_bleed = 1
    # new image height = height of the current tileset + #tiles in column - 1 (bleed)
    target_height = tileset.height + (tileset.nb_tiles_per_column * 2 * nb_pixels_in_bleed) - 2 * nb_pixels_in_bleed
    target_width = tileset.width + (tileset.nb_tiles_per_row * 2 * nb_pixels_in_bleed) - 2 * nb_pixels_in_bleed

    ::MiniMagick::Tool::Convert.new do |convert|
      convert.background('none')

      # Copy the original and resize so that we keep all the image specs
      convert << tileset.original_image_path
      convert.resize("#{target_width}x#{target_height}!")
      convert.fill('white').draw("rectangle 0,0 #{target_width},#{target_height}")
      convert.transparent('white')
      convert.compose('Over')

      # Copy tiles
      tileset.for_each_tile do |tile|
        copy_rect_from(
          convert,
          tileset.original_image_path,
          tile.left,
          tile.top,
          tile.height,
          tile.width,
          tile.column_index * (tile.width + 2 * nb_pixels_in_bleed) + tileset.offset_left,
          tile.row_index * (tile.height + 2 * nb_pixels_in_bleed) + tileset.offset_top
        )
      end

      # Add bleed
      tileset.for_each_tile do |tile|
        copy_rect_from(
          convert,
          tileset.original_image_path,
          tile.left,
          tile.top,
          1,
          tile.width,
          tile.column_index * (tile.width + 2 * nb_pixels_in_bleed) + tileset.offset_left,
          tile.row_index * (tile.height + 2 * nb_pixels_in_bleed) + tileset.offset_top - 1
        ) unless tile.top <= 0
        copy_rect_from(
          convert,
          tileset.original_image_path,
          tile.left,
          tile.bottom - 1,
          1,
          tile.width,
          tile.column_index * (tile.width + 2 * nb_pixels_in_bleed) + tileset.offset_left,
          tile.row_index * (tile.height + 2 * nb_pixels_in_bleed) + tileset.offset_top + tile.height
        ) unless tile.bottom >= tileset.height
        copy_rect_from(
          convert,
          tileset.original_image_path,
          tile.left,
          tile.top,
          tile.height,
          1,
          tile.column_index * (tile.width + 2 * nb_pixels_in_bleed) + tileset.offset_left - 1,
          tile.row_index * (tile.height + 2 * nb_pixels_in_bleed) + tileset.offset_top
        ) unless tile.left <= 0
        copy_rect_from(
          convert,
          tileset.original_image_path,
          tile.right - 1,
          tile.top,
          tile.height,
          1,
          tile.column_index * (tile.width + 2 * nb_pixels_in_bleed) + tileset.offset_left + tile.width,
          tile.row_index * (tile.height + 2 * nb_pixels_in_bleed) + tileset.offset_top
        ) unless tile.right >= tileset.width
      end

      convert.flatten
      convert << result_path
    end

    @logger.info("Result stored in '#{result_path}'")
  end

  def result_path
    return @options[:output] if @options[:output]

    file_name = ::File.basename(@image_path, '.*')
    extension = ::File.extname(@image_path)
    directory = ::File.dirname(@image_path)

    "#{directory}/#{file_name}_result#{extension}"
  end

  def ask_specs
    tile_height =
      @cli.ask('Tile height?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end
    tile_width =
      @cli.ask('Tile width?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end
    margin = @cli.ask('Margin?  ', ::Integer) { |q| q.default = 0 }
    offset_top = @cli.ask('Top Offset?  ', ::Integer) { |q| q.default = 0 }
    offset_left = @cli.ask('Left Offset?  ', ::Integer) { |q| q.default = 0 }

    [tile_height, tile_width, margin, offset_top, offset_left]
  end

  def load_specs_from_file(file_path)
    @logger.info("Extracting specs from '#{file_path}'")
    specs = ::YAML.load_file(file_path)

    begin
      tile_height = specs['specs']['details']['tile_height']
      tile_width = specs['specs']['details']['tile_width']
      margin = specs['specs']['details']['margin']
      offset_top = specs['specs']['details']['offset_top']
      offset_left = specs['specs']['details']['offset_left']
    rescue ::NoMethodError
      raise(::StandardError, 'Invalid specs file')
    end
    [tile_height, tile_width, margin, offset_top, offset_left]
  end

  def find_specs
    specs_file = ::TilesetTooling::Utils.image_spec_file_path(@image_path)
    if !@options[:'skip-specs'] && ::File.exist?(specs_file)
      tile_height, tile_width, margin, offset_top, offset_left = load_specs_from_file(specs_file)
    else
      tile_height, tile_width, margin, offset_top, offset_left = ask_specs
    end
    [tile_height, tile_width, margin, offset_top, offset_left]
  end

  # Asks for information about the image and build a tileset
  def gather_image_information
    tile_height, tile_width, margin, offset_top, offset_left = find_specs

    ::TilesetTooling::Data::TileSet.new(
      image: ::MiniMagick::Image.open(@image_path),
      original_image_path: @image_path,
      tile_height: tile_height,
      tile_width: tile_width,
      margin: margin,
      offset_top: offset_top,
      offset_left: offset_left
    )
  end

  def copy_rect(convert, x1, y1, height, width, x2, y2)
    # convert image \( +clone -crop WxH+X1+Y1 +repage \) -geometry +X2+Y2 -compose over -composite result
    convert.stack do |stack|
      stack.clone.+ # rubocop:disable Lint/Void
      stack.crop("#{width}x#{height}+#{x1}+#{y1}")
      stack.repage.+
    end
    convert.geometry("+#{x2}+#{y2}")
    convert.compose('Over')
    convert.composite
  end

  def copy_rect_from(convert, image_path, x1, y1, height, width, x2, y2)
    convert.stack do |stack|
      stack << image_path
      stack.crop("#{width}x#{height}+#{x1}+#{y1}")
      stack.repage.+
    end
    convert.geometry("+#{x2}+#{y2}")
    convert.compose('Over')
    convert.composite
  end
end
