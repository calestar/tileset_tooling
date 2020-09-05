# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'highline'
require 'semantic_logger'

# Module containing all commands
module ::TilesetTooling::Commands
end

# Basis for all commands
class ::TilesetTooling::Commands::Command
  # Initializer for command basis
  def initialize(options, args)
    @logger = ::SemanticLogger[self.class.name.split('::').last]
    @cli = ::HighLine.new
    @options = options
    @args = args
  end
end

require 'tileset_tooling/commands/insert_bleed'
