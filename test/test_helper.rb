# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test/unit'

require 'mocha/test_unit'

require 'test_assertions'
require 'tileset_tooling/app'

# In case we need debugging, uncomment the following
# ::SemanticLogger.sync!
# ::SemanticLogger.default_level = :trace
# ::SemanticLogger.add_appender(io: $stdout, formatter: :color)

def data_dir
  "#{__dir__}/data/"
end

def get_png_data(name)
  input = "#{data_dir}/#{name}"
  expected = "#{data_dir}/expected/#{name}"

  [input, expected]
end

def output_file_path
  path = "#{data_dir}/tmp_output.png"
  ::File.delete(path) if ::File.exist?(path)
  path
end
