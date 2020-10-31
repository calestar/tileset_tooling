# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data/point'

# Class representing a TileSet's information
class ::TilesetTooling::Data::Tile < ::Dry::Struct
  attribute :tile_top, ::TilesetTooling::Data::Types::Integer
  attribute :tile_left, ::TilesetTooling::Data::Types::Integer
  attribute :height, ::TilesetTooling::Data::Types::Integer
  attribute :width, ::TilesetTooling::Data::Types::Integer

  attribute :margin_top, ::TilesetTooling::Data::Types::Integer
  attribute :margin_left, ::TilesetTooling::Data::Types::Integer
  attribute :margin_bottom, ::TilesetTooling::Data::Types::Integer
  attribute :margin_right, ::TilesetTooling::Data::Types::Integer

  attribute :row_index, ::TilesetTooling::Data::Types::Integer
  attribute :column_index, ::TilesetTooling::Data::Types::Integer

  # Helper to get the bottom coordinate
  def tile_bottom
    tile_top + height
  end

  # Helper to get the right coordinate
  def tile_right
    tile_left + width
  end

  # Helper to get the top-left point of this tile
  def top_left
    ::TilesetTooling::Data::Point.new(x: tile_left, y: tile_top)
  end

  # Helper to get the outer-bottom coordinate
  def full_bottom
    tile_top + height + margin_bottom
  end

  # Helper to get the outer-top coordinate
  def full_top
    tile_top - margin_top
  end

  # Helper to get the outer-right coordinate
  def full_right
    tile_left + width + margin_right
  end

  # Helper to get the outer-left coordinate
  def full_left
    tile_left - margin_left
  end
end
