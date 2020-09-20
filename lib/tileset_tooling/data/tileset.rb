# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data/tile'

# Class representing a TileSet row
class ::TilesetTooling::Data::TileSetRow
  # Default constructor taking a list of tiles
  def initialize(tiles)
    @tiles = tiles
  end

  attr_reader :tiles
end

# Class representing any TileSet's information
class ::TilesetTooling::Data::TileSetBase < ::Dry::Struct
  attribute :height, ::TilesetTooling::Data::Types::Integer
  attribute :width, ::TilesetTooling::Data::Types::Integer
  attribute :tile_height, ::TilesetTooling::Data::Types::Integer
  attribute :tile_width, ::TilesetTooling::Data::Types::Integer
  attribute :margin, ::TilesetTooling::Data::Types::Integer
  attribute :offset_top, ::TilesetTooling::Data::Types::Integer
  attribute :offset_left, ::TilesetTooling::Data::Types::Integer

  # Runs the given bloc on each tile of the tileset
  def for_each_tile(&block)
    rows.each do |row|
      row.tiles.each do |tile|
        block.call(tile)
      end
    end
  end

  # Gets the number of tiles per row
  def nb_tiles_per_row
    rows[0].tiles.length
  end

  # Gets the number of tiles per column
  def nb_tiles_per_column
    rows.length
  end

  # Gets the tile at the specified row/column
  def tile_at(row_index, column_index)
    rows[row_index].tiles[column_index]
  end

  private

  # Computes the tiles and returns them
  def rows
    return @rows unless @rows.nil?

    @rows = []
    top = offset_top
    row_index = 0
    loop do
      left = offset_left
      tiles = []
      margin_top = top.positive? ? margin : 0
      margin_bottom = top + tile_height < height ? margin : 0
      column_index = 0

      loop do
        margin_left = left.positive? ? margin : 0
        margin_right = left + tile_width < width ? margin : 0

        tiles << ::TilesetTooling::Data::Tile.new(
          top: top + margin_top,
          left: left + margin_left,
          height: tile_height,
          width: tile_width,
          margin_top: margin_top,
          margin_left: margin_left,
          margin_bottom: margin_bottom,
          margin_right: margin_right,
          row_index: row_index,
          column_index: column_index
        )
        left += tile_width + margin_left + margin_right
        column_index += 1
        break if left >= width
      end

      @rows << ::TilesetTooling::Data::TileSetRow.new(tiles)
      top += tile_height + margin_top + margin_bottom
      row_index += 1
      break if top >= height
    end

    @rows
  end
end

# Real tileset, associated with an actual image on disk
class ::TilesetTooling::Data::FileTileSet < ::TilesetTooling::Data::TileSetBase
  attribute :image, ::TilesetTooling::Data::Types::ImageType
  attribute :original_image_path, ::TilesetTooling::Data::Types::String

  def self.new(**kwargs)
    image = kwargs[:image]
    kwargs[:image] = image
    kwargs[:height] = image.height
    kwargs[:width] = image.width

    super(**kwargs)
  end
end

# Virtual tileset, not associated with an actual image
class ::TilesetTooling::Data::VirtualTileSet < ::TilesetTooling::Data::TileSetBase
end
