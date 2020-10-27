# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'
require 'tileset_tooling/utils'

require 'yaml'

# Command used to insert bleed around tiles
class ::TilesetTooling::Commands::InsertBleed < ::TilesetTooling::Commands::Command
  # Constructor, initializes a few internal
  def initialize(options, args, specs_loader)
    @specs_loader = specs_loader
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

    if tileset.margin.positive?
      modify_margin(tileset)
    else
      add_margin(tileset)
    end

    @logger.info("Result stored in '#{result_path}'")
  end

  private

  def modify_margin(tileset)
    ::MiniMagick::Tool::Convert.new do |convert|
      convert.background('none')
      convert << tileset.original_image_path

      tileset.for_each_tile do |tile|
        generate_bleed(convert, tileset, tile)
      end

      convert.flatten
      convert << result_path
    end
  end

  def add_margin(tileset)
    nb_pixels_in_bleed = 1
    new_tileset = ::TilesetTooling::Utils.tileset_with_margin_from(tileset, nb_pixels_in_bleed)
    image_path = tileset.original_image_path

    ::MiniMagick::Tool::Convert.new do |convert|
      convert.background('none')

      # Copy the original and resize so that we keep all the image specs
      convert << image_path
      convert.resize("#{new_tileset.width}x#{new_tileset.height}!")
      convert.fill('white').draw("rectangle 0,0 #{new_tileset.width},#{new_tileset.height}").transparent('white')
      convert.compose('Over')

      # Copy tiles and bled
      tileset.for_each_tile do |tile|
        dest = new_tileset.tile_at(tile.row_index, tile.column_index)
        copy_tile(convert, image_path, tile, dest)
        generate_bleed(convert, tileset, tile, destination: dest, image_path: image_path)
      end

      convert.flatten
      convert << result_path
    end
  end

  def result_path
    return @options[:output] if @options[:output]

    file_name = ::File.basename(@image_path, '.*')
    extension = ::File.extname(@image_path)
    directory = ::File.dirname(@image_path)

    "#{directory}/#{file_name}_result#{extension}"
  end

  def gather_image_information
    specs = @specs_loader.find_specs_for(@image_path, @options[:'skip-specs'])

    ::TilesetTooling::Data::FileTileSet.new(
      image: ::MiniMagick::Image.open(@image_path),
      original_image_path: @image_path,
      tile_height: specs.tile_height,
      tile_width: specs.tile_width,
      margin: specs.margin,
      offset_top: specs.offset_top,
      offset_left: specs.offset_left
    )
  end

  def copy_rect(convert, width, height, source, destination, image_path: nil)
    convert.stack do |stack|
      if image_path.nil?
        stack.clone.+
      else
        stack << image_path
      end
      stack.crop("#{width}x#{height}+#{source.x}+#{source.y}").repage.+
    end
    convert.geometry("+#{destination.x}+#{destination.y}")
    convert.compose('Over').composite
  end

  def copy_tile(convert, image_path, source, destination)
    copy_rect(convert, source.width, source.height, source.top_left, destination.top_left, image_path: image_path)
  end

  def generate_bleed(convert, tileset, source, destination: nil, image_path: nil)
    destination = source if destination.nil?

    # Top
    source_coord = ::TilesetTooling::Data::Point.new(x: source.left, y: source.top)
    dest_coord = ::TilesetTooling::Data::Point.new(x: destination.left, y: destination.top - 1)
    copy_rect(convert, source.width, 1, source_coord, dest_coord, image_path: image_path) unless source.top <= 0

    # Bottom
    source_coord = ::TilesetTooling::Data::Point.new(x: source.left, y: source.bottom - 1)
    dest_coord = ::TilesetTooling::Data::Point.new(x: destination.left, y: destination.bottom)
    copy_rect(convert, source.width, 1, source_coord, dest_coord, image_path: image_path) unless source.bottom >= tileset.height

    # Left
    source_coord = ::TilesetTooling::Data::Point.new(x: source.left, y: source.top)
    dest_coord = ::TilesetTooling::Data::Point.new(x: destination.left - 1, y: destination.top)
    copy_rect(convert, 1, source.height, source_coord, dest_coord, image_path: image_path) unless source.left <= 0

    # Right
    source_coord = ::TilesetTooling::Data::Point.new(x: source.right - 1, y: source.top)
    dest_coord = ::TilesetTooling::Data::Point.new(x: destination.right, y: destination.top)
    copy_rect(convert, 1, source.height, source_coord, dest_coord, image_path: image_path) unless source.right >= tileset.width
  end
end
