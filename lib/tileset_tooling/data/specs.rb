# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Structure representing the specs associated with a tileset
class ::TilesetTooling::Data::Specs < ::Dry::Struct
  attribute :tile_height, ::TilesetTooling::Data::Types::Integer
  attribute :tile_width, ::TilesetTooling::Data::Types::Integer
  attribute :margin, ::TilesetTooling::Data::Types::Integer
  attribute :offset_top, ::TilesetTooling::Data::Types::Integer
  attribute :offset_left, ::TilesetTooling::Data::Types::Integer
  attribute :nb_rows, ::TilesetTooling::Data::Types::Integer.optional
  attribute :nb_columns, ::TilesetTooling::Data::Types::Integer.optional
  attribute :pattern, ::TilesetTooling::Data::Types::PatternType.optional
end
