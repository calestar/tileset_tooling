# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::TestInsertBleed < ::Test::Unit::TestCase
  def test_margin_required
    input, expected = get_png_data('simple_no_margin.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
    output = output_file_path
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns([16, 16, 0, 0, 0])
    command.unpack!
    command.run
    assert ::File.exist?(expected)
    assert ::File.exist?(output)
    output_signature = ::TilesetTooling::Utils.image_signature(output)
    expected_signature = ::TilesetTooling::Utils.image_signature(expected)
    assert_equal(expected_signature, output_signature)
  end

  def test_simple_file
    input, expected = get_png_data('simple_with_margin.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
    output = output_file_path
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns([16, 16, 1, 0, 0])
    command.unpack!
    command.run
    assert ::File.exist?(expected)
    assert ::File.exist?(output)
    output_signature = ::TilesetTooling::Utils.image_signature(output)
    expected_signature = ::TilesetTooling::Utils.image_signature(expected)
    assert_equal(expected_signature, output_signature)
  end

  def test_simple_file_with_specs
    input, expected = get_png_data('simple_with_specs.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
    output = output_file_path
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
    command.unpack!
    command.run
    assert ::File.exist?(expected)
    assert ::File.exist?(output)
    output_signature = ::TilesetTooling::Utils.image_signature(output)
    expected_signature = ::TilesetTooling::Utils.image_signature(expected)
    assert_equal(expected_signature, output_signature)
  end

  def test_simple_file_with_bad_specs
    input, = get_png_data('simple_with_bad_specs.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
    output = output_file_path
    options = { output: output }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
    command.unpack!
    assert_raise ::StandardError, 'Invalid specs file' do
      command.run
    end
  end

  def test_simple_file_with_skip_specs
    input, expected = get_png_data('simple_with_bad_specs.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
    output = output_file_path
    options = { output: output, 'skip-specs': true }
    args = [input]
    command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns([16, 16, 1, 0, 0])
    command.unpack!
    command.run
    assert ::File.exist?(expected)
    assert ::File.exist?(output)
    output_signature = ::TilesetTooling::Utils.image_signature(output)
    expected_signature = ::TilesetTooling::Utils.image_signature(expected)
    assert_equal(expected_signature, output_signature)
  end
end
