# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Module containing all types to be used for Dry::Struct structures
module ::TilesetTooling::Data::Types
  include ::Dry.Types()

  ImageType = ::TilesetTooling::Data::Types.Instance(::MiniMagick::Image)

  public_constant :ImageType
end
