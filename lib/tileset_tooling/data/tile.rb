# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

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

  # Helper to print the information of the tile
  def to_s
    "#{top},#{left} [#{margin_top},#{margin_left},#{margin_bottom},#{margin_right}]"
  end

  # Helper to get the bottom coordinate
  def bottom
    top + height
  end

  # Helper to get the right coordinate
  def right
    left + width
  end
end
