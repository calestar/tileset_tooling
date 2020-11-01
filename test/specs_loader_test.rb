# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::TestSpecsLoader < ::Test::Unit::TestCase
  [
    ['missing_field', 'bad_missing_field.specs', ::KeyError],
    ['wrong_pattern', 'bad_wrong_pattern.specs', nil]
  ].each do |scenario, filename, expected_exception|
    test_name = "test_badnormalspecs_file_#{scenario}"
    define_method(test_name) do
      filepath = "#{data_dir}/specs/#{filename}"
      assert ::File.exist?(filepath)
      loader = ::TilesetTooling::Utils::SpecsLoader.new

      if expected_exception
        assert_raise expected_exception do
          loader.load_specs_from(filepath)
        end
      else
        specs = loader.load_specs_from(filepath)
        assert !specs.nil?
      end
    end
  end

  [
    ['missing_field_create', 'bad_missing_field_create.specs', ::KeyError],
    ['wrong_checkerboard', 'bad_wrong_checkerboard.specs', ::StandardError],
    ['wrong_pattern', 'bad_wrong_pattern.specs', ::StandardError]
  ].each do |scenario, filename, expected_exception|
    test_name = "test_badcreatespecs_file_#{scenario}"
    define_method(test_name) do
      filepath = "#{data_dir}/specs/#{filename}"
      assert ::File.exist?(filepath)
      loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
      assert_raise expected_exception do
        loader.load_specs_from(filepath)
      end
    end
  end
end
