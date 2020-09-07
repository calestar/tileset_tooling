# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

When(/^I get help/) do
  step %(I run `#{::Configuration.instance.app_name} help`)
end

When(/^I get help for "([^"]*)"$/) do |command|
  step %(I run `#{::Configuration.instance.app_name} #{command} help`)
end
