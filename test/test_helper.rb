# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test/unit'
require 'mocha/test_unit'

require 'tileset_tooling/app'

def get_png_data(name)
  input = "#{__dir__}/data/#{name}"
  expected = "#{__dir__}/data/expected/#{name}"

  [input, expected]
end

def output_file_path
  "#{__dir__}/data/tmp_output.png"
end
