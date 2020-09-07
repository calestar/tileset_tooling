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

  file_identical = ::FileUtils.identical?(expected_output_path, output_path)

  expect(file_identical).to be true
end
