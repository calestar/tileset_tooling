# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data/point'

# Class representing a TileSet's information
class ::TilesetTooling::Data::Tile < ::Dry::Struct
  attribute :top, ::TilesetTooling::Data::Types::Integer
  attribute :left, ::TilesetTooling::Data::Types::Integer
  attribute :height, ::TilesetTooling::Data::Types::Integer
  attribute :width, ::TilesetTooling::Data::Types::Integer

  attribute :margin_top, ::TilesetTooling::Data::Types::Integer
  attribute :margin_left, ::TilesetTooling::Data::Types::Integer
  attribute :margin_bottom, ::TilesetTooling::Data::Types::Integer
  attribute :margin_right, ::TilesetTooling::Data::Types::Integer

  attribute :row_index, ::TilesetTooling::Data::Types::Integer
  attribute :column_index, ::TilesetTooling::Data::Types::Integer

  # Helper to get the bottom coordinate
  def bottom
    top + height
  end

  # Helper to get the right coordinate
  def right
    left + width
  end

  # Helper to get the top-left point of this tile
  def top_left
    ::TilesetTooling::Data::Point.new(x: left, y: top)
  end
end
