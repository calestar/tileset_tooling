# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'fileutils'

When('I create a new tileset') do
  @output_path = "#{test_data_dir}/create_result.png"
  @specs_output_path = "#{test_data_dir}/create_result.specs"
  step %(I run `#{::Configuration.instance.app_name} tileset create --overwrite #{@output_path}` interactively)
end

When('I create a new tileset without overwriting output') do
  @output_path = "#{test_data_dir}/create_result.png"
  @specs_output_path = "#{test_data_dir}/create_result.specs"
  step %(I run `#{::Configuration.instance.app_name} tileset create #{@output_path}` interactively)
end

When(/I create a new tileset using specs "([^"]*)"/) do |specs_file|
  @output_path = "#{test_data_dir}/create_result.png"
  @specs_output_path = "#{test_data_dir}/create_result.specs"
  options = ['--overwrite', "--specs-file=#{test_data_dir}/#{specs_file}"]
  step %(I run `#{::Configuration.instance.app_name} tileset create #{options.join(' ')} #{@output_path}` interactively)
end

When('Tileset creation file already exists') do
  path = "#{test_data_dir}/create_result.png"
  ::FileUtils.touch(path)
end
