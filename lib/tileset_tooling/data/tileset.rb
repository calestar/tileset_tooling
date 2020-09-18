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

# Class representing a TileSet's information
class ::TilesetTooling::Data::TileSet < ::Dry::Struct
  attribute :image, ::TilesetTooling::Data::Types::ImageType
  attribute :original_image_path, ::TilesetTooling::Data::Types::String
  attribute :tile_height, ::TilesetTooling::Data::Types::Integer
  attribute :tile_width, ::TilesetTooling::Data::Types::Integer
  attribute :margin, ::TilesetTooling::Data::Types::Integer
  attribute :offset_top, ::TilesetTooling::Data::Types::Integer
  attribute :offset_left, ::TilesetTooling::Data::Types::Integer

  # Helper to print all information in the image
  def to_s
    %(
Image '#{original_image_path}'
  Tile height: #{tile_height}
  Tile width: #{tile_width}
  Margin: #{margin}
  Top offset: #{offset_top}
  Left offset: #{offset_left}
  Number of tiles: #{rows.count * rows[0].tiles.count})
  end

  # Runs the given bloc on each tile of the tileset
  def for_each_tile(&block)
    rows.each do |row|
      row.tiles.each do |tile|
        block.call(tile)
      end
    end
  end

  # Gets the height of the tileset/image
  def height
    image.height
  end

  # Gets the width of the tileset/image
  def width
    image.width
  end

  # Gets the number of tiles per row
  def nb_tiles_per_row
    rows[0].tiles.length
  end

  # Gets the number of tiles per column
  def nb_tiles_per_column
    rows.length
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
