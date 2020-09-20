# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Simple structure to represent a point (X,Y)
class ::TilesetTooling::Data::Point < ::Dry::Struct
  attribute :x, ::TilesetTooling::Data::Types::Integer
  attribute :y, ::TilesetTooling::Data::Types::Integer
end
