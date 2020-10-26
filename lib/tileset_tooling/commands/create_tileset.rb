# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'
require 'tileset_tooling/utils'

require 'yaml'

# Command used to create new tilesets
class ::TilesetTooling::Commands::CreateTileset < ::TilesetTooling::Commands::Command
  # Validates arguments/options and unpacks them
  def unpack!
    raise(::StandardError, 'Missing argument') unless @args.count == 1

    @image_path = @args.shift

    raise(::StandardError, "File '#{@image_path}' already exists") if ::File.exist?(@image_path)
  end

  # Runs this command
  def run
    @logger.info("Creating new tileset at '#{@image_path}'")
  end
end
