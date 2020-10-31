# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/patterns'

# Module containing all types to be used for Dry::Struct structures
module ::TilesetTooling::Data::Types
  include ::Dry.Types()

  ImageType = ::TilesetTooling::Data::Types.Instance(::MiniMagick::Image)
  PatternType = ::TilesetTooling::Data::Types.Instance(::TilesetTooling::Patterns::PatternBase)

  public_constant :ImageType
  public_constant :PatternType
end
