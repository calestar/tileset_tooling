# frozen_string_literal: true

require 'gli'

require 'tileset_tooling/version.rb'

module TilesetTooling
  # Core application for the project; sets up the GLI configuration and such
  class App
    extend GLI::App

    program_desc 'Describe your application here'

    version TilesetTooling::VERSION

    subcommand_option_handling :normal
    arguments :strict

    pre do
      true
    end

    post do
    end

    on_error do
      true
    end
  end
end
