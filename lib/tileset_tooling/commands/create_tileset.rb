# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'
require 'tileset_tooling/utils'

require 'yaml'

# Command used to create new tilesets
class ::TilesetTooling::Commands::CreateTileset < ::TilesetTooling::Commands::Command
  # Constructor, initializes a few internal
  def initialize(options, args, specs_loader)
    @specs_loader = specs_loader
    super(options, args)
  end

  # Validates arguments/options and unpacks them
  def unpack!
    raise(::StandardError, 'Missing argument') unless @args.count == 1

    overwrite = @options[:overwrite]
    @result_path = @args.shift

    raise(::StandardError, "File '#{@result_path}' already exists") if ::File.exist?(@result_path) && !overwrite
  end

  # Runs this command
  def run
    @logger.info("Creating new tileset at '#{@result_path}'")
    tileset = gather_image_information

    ::MiniMagick::Tool::Convert.new do |convert|
      convert.size("#{tileset.width}x#{tileset.height}")
      convert.canvas('transparent')

      # Copy tiles and bled
      tileset.for_each_tile do |tile|
        color = tileset.pattern.color_for(tile.row_index, tile.column_index)
        convert.fill(color).draw("rectangle #{tile.tile_left},#{tile.tile_top} #{tile.tile_right - 1},#{tile.tile_bottom - 1}")
      end

      convert << @result_path
    end
  end

  private

  def gather_image_information
    specs = @specs_loader.load_specs_from(@options[:'specs-file'])

    ::TilesetTooling::Data::NewTileSet.new(
      tile_height: specs.tile_height,
      tile_width: specs.tile_width,
      margin: specs.margin,
      offset_top: specs.offset_top,
      offset_left: specs.offset_left,
      nb_rows: specs.nb_rows,
      nb_columns: specs.nb_columns,
      pattern: specs.pattern
    )
  end
end
