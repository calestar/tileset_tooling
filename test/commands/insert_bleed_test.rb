# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::TestInsertBleed < ::Test::Unit::TestCase
  def test_margin_required
    input, = get_png_data('simple_no_margin.png')
    command = ::TilesetTooling::Commands::InsertBleed.new({}, [input])
    command.expects(:find_specs).returns([16, 16, 0, 0, 0])
    command.unpack!

    assert_raise ::StandardError do
      command.run
    end
  end

  def test_simple_file
    input, expected = get_png_data('simple_with_margin.png')
    output = output_file_path
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args)
    command.expects(:find_specs).returns([16, 16, 1, 0, 0])
    command.unpack!
    command.run
    assert ::File.exist?(expected)
    assert ::File.exist?(output)
    assert ::FileUtils.identical?(expected, output)
  end
end
