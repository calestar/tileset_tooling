# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

Then(/^generated file should be the same as data result "([^"]*)"/) do |data_path_name|
  expected_output_path = test_result_path(data_path_name)

  # Try two paths: normal output, and hacked aruba tmp one
  output_path = @output_path
  aruba_output_path = "#{::Configuration.instance.working_directory}/#{@output_path}"
  output_path = aruba_output_path unless ::File.exist?(output_path)

  expect(::File.exist?(expected_output_path)).to be true
  expect(::File.exist?(output_path)).to be true

  expected_signature = image_signature(expected_output_path)
  output_signature = image_signature(output_path)

  expect(expected_signature).to eq output_signature
end

Then(/^generated specs file should be the same as specs result "([^"]*)"/) do |data_path_name|
  expected_output_path = test_result_path(data_path_name)

  # Try two paths: normal output, and hacked aruba tmp one
  output_path = @specs_output_path
  aruba_output_path = "#{::Configuration.instance.working_directory}/#{@specs_output_path}"
  output_path = aruba_output_path unless ::File.exist?(output_path)

  expect(::File.exist?(expected_output_path)).to be true
  expect(::File.exist?(output_path)).to be true

  expected_specs = ::YAML.load_file(expected_output_path)
  actual_specs = ::YAML.load_file(output_path)
  expect(actual_specs).to eq expected_specs
end
