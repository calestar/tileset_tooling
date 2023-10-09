# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'mini_magick'

# A few random utilities
module ::TilesetTooling::Utils
  module_function

  # Generate a signature from the image data
  def image_signature(image_path)
    ::MiniMagick::Tool::Identify.new do |identity|
      identity.quiet
      identity.format('%#\\n')
      identity << image_path
    end
  end

  # Generates a virtual tileset with added margin to be used for coordinate
  def tileset_with_margin_from(original_tileset, nb_pixels_in_margin)
    raise(::StandardError, 'Original tileset already contains a margin') if original_tileset.margin.nonzero?

    new_height = original_tileset.height + (original_tileset.nb_tiles_per_column * 2 * nb_pixels_in_margin) - (nb_pixels_in_margin * 2)
    new_width = original_tileset.width + (original_tileset.nb_tiles_per_row * 2 * nb_pixels_in_margin) - (nb_pixels_in_margin * 2)

    ::TilesetTooling::Data::VirtualTileSet.new(
      tile_height: original_tileset.tile_height,
      tile_width: original_tileset.tile_width,
      margin: nb_pixels_in_margin,
      offset_top: original_tileset.offset_top,
      offset_left: original_tileset.offset_left,
      height: new_height,
      width: new_width
    )
  end
end
