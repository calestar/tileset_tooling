# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

When(/^I insert bleed to test data "([^"]*)"$/) do |data_name|
  image_path = test_data_path(data_name)
  file_name = ::File.basename(image_path, '.*')
  extension = ::File.extname(image_path)
  directory = ::File.dirname(image_path)

  @output_path = "#{directory}/#{file_name}_result#{extension}"
  step %(I run `#{::Configuration.instance.app_name} bleed insert #{image_path}` interactively)
end

When(/^I insert bleed to test data "([^"]*)" and output to "([^"]*)"/) do |data_name, output_path|
  @output_path = output_path
  image_path = test_data_path(data_name)
  step %(I run `#{::Configuration.instance.app_name} bleed insert --output #{@output_path} #{image_path}` interactively)
end
