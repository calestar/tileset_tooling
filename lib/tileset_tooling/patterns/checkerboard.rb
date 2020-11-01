# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Pattern that represents a two-color checkerboard
class ::TilesetTooling::Patterns::Checkerboard < ::TilesetTooling::Patterns::PatternBase
  # Initializes a new Checkerboard pattern using the two specified colors
  def initialize(color1, color2)
    super()
    @color1 = color1
    @color2 = color2
  end

  # Gets the color in the checkerboard for the given tile
  def color_for(row_index, column_index)
    first, second = row_index.even? ? [@color1, @color2] : [@color2, @color1]
    column_index.even? ? first : second
  end

  # Used when serializing to YAML for compatiblity
  def to_yaml_string
    "checkerboard;#{@color1}&#{@color2}"
  end

  # Used when asking the user a choice of patterns
  def to_human_choice
    "Checkerboard pattern (#{@color1} and #{@color2})"
  end
end
