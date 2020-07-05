# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'gli'
require 'semantic_logger'

require 'tileset_tooling/version.rb'
require 'tileset_tooling/commands/insert_bleed.rb'

# Core module for the project
module ::TilesetTooling
end

# Core application for the project; sets up the GLI configuration and such
class ::TilesetTooling::App
  extend ::GLI::App

  program_desc 'Bits of tooling I use for working with tilesets'

  version ::TilesetTooling::VERSION

  subcommand_option_handling :normal
  arguments :strict

  pre do
    # Set the global default log level and add appender
    ::SemanticLogger.sync!
    ::SemanticLogger.default_level = :trace
    ::SemanticLogger.add_appender(io: ::STDOUT, formatter: :color)

    true
  end

  post do
  end

  on_error do
    true
  end
end
