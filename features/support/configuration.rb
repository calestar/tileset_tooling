# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

class ::Configuration
  include ::Singleton

  def initialize
    @app_name = 'tileset_tooling'
    @working_directory = nil
  end

  attr_reader :app_name
  attr_accessor :working_directory
end

::Aruba.configure do |config|
  ::Configuration.instance.working_directory = config.working_directory
end
