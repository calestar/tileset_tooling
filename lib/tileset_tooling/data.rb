# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'dry-struct'
require 'mini_magick'

# Module containing all data-types that are used across the project
module ::TilesetTooling::Data
end

# Needs to be first
require 'tileset_tooling/data/types'

require 'tileset_tooling/data/point'
require 'tileset_tooling/data/tile'
require 'tileset_tooling/data/tileset'
