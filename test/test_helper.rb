# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test/unit'
require 'mocha/test_unit'

require 'tileset_tooling/app'
require 'test_assertions'

# In case we need debugging, uncomment the following
# ::SemanticLogger.sync!
# ::SemanticLogger.default_level = :trace
# ::SemanticLogger.add_appender(io: $stdout, formatter: :color)

def get_png_data(name)
  input = "#{__dir__}/data/#{name}"
  expected = "#{__dir__}/data/expected/#{name}"

  [input, expected]
end

def output_file_path
  "#{__dir__}/data/tmp_output.png"
end
