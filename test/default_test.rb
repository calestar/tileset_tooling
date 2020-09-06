# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::DefaultTest < ::Test::Unit::TestCase
  def test_margin_required
    command = ::TilesetTooling::Commands::InsertBleed.new({}, ["#{__dir__}/data/simple_no_margin.png"])
    command.expects(:find_specs).returns([16, 16, 0, 0, 0])
    command.unpack!

    assert_raise ::StandardError do
      command.run
    end
  end

  def test_simple_file
    input = "#{__dir__}/data/simple_with_margin.png"
    expected = "#{__dir__}/data/expected/simple_with_margin.png"
    output = "#{__dir__}/data/output.png"
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args)
    command.expects(:find_specs).returns([16, 16, 1, 0, 0])
    command.unpack!
    command.run
    assert ::FileUtils.identical?(expected, output)
  end
end
