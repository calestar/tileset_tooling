# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::TestCreateTileset < ::Test::Unit::TestCase
  def specs(nb_rows, nb_columns, pattern, size: 16, margin: 0, offset_top: 0, offset_left: 0)
    ::TilesetTooling::Data::Specs.new(
      tile_height: size,
      tile_width: size,
      margin: margin,
      offset_top: offset_top,
      offset_left: offset_left,
      nb_rows: nb_rows,
      nb_columns: nb_columns,
      pattern: pattern
    )
  end

  def test_new_nomargin_nooffset
    _, expected = get_png_data('new_5x2_16_nomargin_nooffset.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
    pattern = ::TilesetTooling::Patterns::Checkerboard.new(:black, :white)
    output = output_file_path
    options = {}
    args = [output]
    command = ::TilesetTooling::Commands::CreateTileset.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns(specs(5, 2, pattern))
    command.unpack!
    command.run
    assert_signature_of(output, expected)
  end

  def test_new_margin_nooffset
    _, expected = get_png_data('new_2x5_16_margin_nooffset.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
    pattern = ::TilesetTooling::Patterns::Checkerboard.new(:black, :white)
    output = output_file_path
    options = {}
    args = [output]
    command = ::TilesetTooling::Commands::CreateTileset.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns(specs(2, 5, pattern, margin: 1))
    command.unpack!
    command.run
    assert_signature_of(output, expected)
  end

  def test_new_margin_topoffset
    _, expected = get_png_data('new_3x3_16_margin_topoffset.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
    pattern = ::TilesetTooling::Patterns::Checkerboard.new(:black, :white)
    output = output_file_path
    options = {}
    args = [output]
    command = ::TilesetTooling::Commands::CreateTileset.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns(specs(3, 3, pattern, margin: 1, offset_top: 2))
    command.unpack!
    command.run
    assert_signature_of(output, expected)
  end

  def test_new_margin_bothoffset
    _, expected = get_png_data('new_3x3_16_margin_bothoffset.png')
    specs_loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
    pattern = ::TilesetTooling::Patterns::Checkerboard.new(:black, :white)
    output = output_file_path
    options = {}
    args = [output]
    command = ::TilesetTooling::Commands::CreateTileset.new(options, args, specs_loader)
    specs_loader.expects(:ask_specs).returns(specs(3, 3, pattern, margin: 1, offset_top: 2, offset_left: 3))
    command.unpack!
    command.run
    assert_signature_of(output, expected)
  end
end
