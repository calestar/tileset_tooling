# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'

# Command used to insert bleed around tiles
class ::TilesetTooling::Commands::InsertBleed < ::TilesetTooling::Commands::Command
  # Default initializer
  def initialize(options, args)
    super(options, args)
  end

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

    raise(::StandardError, 'Current implementation needs an existing margin') unless tileset.margin.positive?

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

  private

  def result_path
    file_name = ::File.basename(@image_path, '.*')
    extension = ::File.extname(@image_path)
    directory = ::File.dirname(@image_path)

    "#{directory}/#{file_name}_result#{extension}"
  end

  # Asks for information about the image and build a tileset
  def gather_image_information
    ::TilesetTooling::Data::TileSet.new(
      image: ::MiniMagick::Image.open(@image_path),
      original_image_path: @image_path,
      tile_height: @cli.ask('Tile height?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end,
      tile_width: @cli.ask('Tile width?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end,
      margin: @cli.ask('Margin?  ', ::Integer) { |q| q.default = 0 },
      offset_top: @cli.ask('Top Offset?  ', ::Integer) { |q| q.default = 0 },
      offset_left: @cli.ask('Left Offset?  ', ::Integer) { |q| q.default = 0 }
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
end
