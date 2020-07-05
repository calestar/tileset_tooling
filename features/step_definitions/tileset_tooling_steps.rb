# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

When(/^I get help for "([^"]*)"$/) do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end
