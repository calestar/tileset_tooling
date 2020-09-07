# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/utils'

def test_data_path(name)
  "#{__dir__}/../../test/data/#{name}"
end

def test_result_path(name)
  "#{__dir__}/../../test/data/expected/#{name}"
end

def image_signature(path)
  ::TilesetTooling::Utils.image_signature(path)
end
