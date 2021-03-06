# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'gli'
require 'mini_magick'
require 'semantic_logger'

require 'tileset_tooling/version'
require 'tileset_tooling/commands'
require 'tileset_tooling/utils'

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
    ::SemanticLogger.add_appender(io: $stdout, formatter: :color)

    # ::MiniMagick.logger.level = ::Logger::DEBUG
    true
  end

  post do
  end

  on_error do |error|
    puts(error)
    puts(error.backtrace)
    true
  end

  desc 'Commands relating to bleed around tiles'
  command :bleed do |bleed_command|
    bleed_command.arg(:input_file)
    bleed_command.desc('Inserts a bleed around tiles')
    bleed_command.command(:insert) do |insert_command|
      insert_command.switch([:'skip-specs'], desc: 'Skips the reading of the specs')
      insert_command.flag([:output], default_value: nil, desc: 'Path where to store result', arg_name: 'path')
      insert_command.action do |_, options, args|
        specs_loader = ::TilesetTooling::Utils::SpecsLoader.new
        command = ::TilesetTooling::Commands::InsertBleed.new(options, args, specs_loader)
        command.unpack!
        command.run
      end
    end
  end

  desc 'Commands relating to tilesets'
  command :tileset do |tileset_command|
    tileset_command.arg(:output_file)
    tileset_command.desc('Creates a new tileset')
    tileset_command.command(:create) do |create_command|
      create_command.switch([:overwrite], default_value: false, desc: 'Overwrites the output file if it already exists')
      create_command.flag(
        [:'specs-file'],
        default_value: nil,
        desc: 'Defines the specs file to read instead of asking the user'
      )
      create_command.switch(
        [:'no-new-specs-file'],
        default_value: false,
        desc: 'Do not generate new spec file on tileset creation'
      )
      create_command.action do |_, options, args|
        specs_loader = ::TilesetTooling::Utils::SpecsLoader.new(for_new_image: true)
        command = ::TilesetTooling::Commands::CreateTileset.new(options, args, specs_loader)
        command.unpack!
        command.run
      end
    end
  end
end
