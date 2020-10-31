# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'tileset_tooling/data'
require 'tileset_tooling/patterns'

# Class used to find/load specs for a given image
class ::TilesetTooling::Utils::SpecsLoader
  # Constructor, initializes a few internals
  def initialize(for_new_image: false)
    @for_new_image = for_new_image
    @logger = ::SemanticLogger[self.class.name.split('::').last]
    @cli = ::HighLine.new
  end

  # Tries to find specs for the given image path
  def find_specs_for(image_path, skip_specs_file)
    specs_file = image_spec_file_path(image_path)
    if !skip_specs_file && ::File.exist?(specs_file)
      load_specs_from_file(specs_file)
    else
      ask_specs
    end
  end

  # Loads the specs from the given file or asks for it
  def load_specs_from(specs_file)
    if specs_file && ::File.exist?(specs_file)
      load_specs_from_file(specs_file)
    else
      ask_specs
    end
  end

  private

  # Gets the path to the spec file that should go with the given image
  def image_spec_file_path(image_path)
    file_name = ::File.basename(image_path, '.*')
    directory = ::File.dirname(image_path)

    "#{directory}/#{file_name}.specs"
  end

  def ask_specs
    tile_height =
      @cli.ask('Tile height?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end
    tile_width =
      @cli.ask('Tile width?  ', ::Integer) do |q|
        q.default = 0
        q.in = 1..256
      end
    margin = @cli.ask('Margin?  ', ::Integer) { |q| q.default = 0 }
    offset_top = @cli.ask('Top Offset?  ', ::Integer) { |q| q.default = 0 }
    offset_left = @cli.ask('Left Offset?  ', ::Integer) { |q| q.default = 0 }

    if @for_new_image
      nb_rows =
        @cli.ask('Number of rows of tiles?  ', ::Integer) do |q|
          q.default = 0
          q.in = 1..256
        end
      nb_columns =
        @cli.ask('Number of columns of tiles?  ', ::Integer) do |q|
          q.default = 0
          q.in = 1..256
        end
      pattern =
        pattern_from_str(
          @cli.choose do |menu|
            menu.choice('Checkerboard pattern (black and white)') { 'black&white' }
            menu.choice('Checkerboard pattern (green and yellow)') { 'green&yellow' }
          end
        )
    end

    ::TilesetTooling::Data::Specs.new(
      tile_height: tile_height,
      tile_width: tile_width,
      margin: margin,
      offset_top: offset_top,
      offset_left: offset_left,
      pattern: pattern,
      nb_rows: nb_rows,
      nb_columns: nb_columns
    )
  end

  def load_specs_from_file(file_path)
    @logger.info("Extracting specs from '#{file_path}'")
    yaml = ::YAML.load_file(file_path)

    begin
      specs = yaml.fetch('specs')
      details = specs.fetch('details')

      tile_height = details.fetch('tile_height')
      tile_width = details.fetch('tile_width')
      margin = details.fetch('margin')
      offset_top = details.fetch('offset_top')
      offset_left = details.fetch('offset_left')

      pattern = pattern_from_str(specs.fetch('pattern')) if @for_new_image
      nb_rows = specs.fetch('nb_rows') if @for_new_image
      nb_columns = specs.fetch('nb_columns') if @for_new_image
    rescue ::NoMethodError
      raise(::StandardError, 'Invalid specs file')
    end

    ::TilesetTooling::Data::Specs.new(
      tile_height: tile_height,
      tile_width: tile_width,
      margin: margin,
      offset_top: offset_top,
      offset_left: offset_left,
      pattern: pattern,
      nb_rows: nb_rows,
      nb_columns: nb_columns
    )
  end

  def pattern_from_str(pattern_str)
    case pattern_str
    when 'black&white'
      ::TilesetTooling::Patterns::Checkerboard.new(:black, :white)
    when 'green&yellow'
      ::TilesetTooling::Patterns::Checkerboard.new(:green, :yellow)
    else
      raise(::StandardError, "Unknown pattern '#{pattern_str}'")
    end
  end
end
