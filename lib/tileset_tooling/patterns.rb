# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Module containing all patterns that can be used to create a new tileset
module ::TilesetTooling::Patterns
end

# Basis for all patterns
class ::TilesetTooling::Patterns::PatternBase
  # Base class for all patterns
end

require 'tileset_tooling/patterns/checkerboard'

# Factory used to access patterns
class ::TilesetTooling::PatternFactory
  # Initializes a pattern factory with default valid patterns
  def initialize
    @patterns = [::TilesetTooling::Patterns::Checkerboard.new(:black, :white), ::TilesetTooling::Patterns::Checkerboard.new(:green, :yellow)]
  end

  # Helper to iterate on each valid patterns
  def for_each_patterns(&block)
    @patterns.each do |pattern|
      block.call(pattern)
    end
  end

  # Helper to find the pattern instance from the yaml string
  def find_pattern_from_yaml(pattern_name)
    @patterns.each do |pattern|
      return pattern if pattern.to_yaml_string == pattern_name
    end

    raise(::StandardError, "Could not find pattern from string '#{pattern_name}'")
  end
end
