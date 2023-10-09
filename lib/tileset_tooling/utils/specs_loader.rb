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
    @pattern_factory = ::TilesetTooling::PatternFactory.new
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

  # Saves the given specs to the file
  def save_specs_for(image_path, specs)
    specs_file = image_spec_file_path(image_path)
    save_specs_to_file(specs_file, specs)
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
        @cli.choose do |menu|
          @pattern_factory.for_each_patterns do |choice|
            menu.choice(choice.to_human_choice) { choice }
          end
        end
    end

    ::TilesetTooling::Data::Specs.new(tile_height:, tile_width:, margin:, offset_top:, offset_left:, pattern:, nb_rows:, nb_columns:)
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

      pattern = @pattern_factory.find_pattern_from_yaml(specs.fetch('pattern')) if @for_new_image
      nb_rows = specs.fetch('nb_rows') if @for_new_image
      nb_columns = specs.fetch('nb_columns') if @for_new_image
    rescue ::NoMethodError
      raise(::StandardError, 'Invalid specs file')
    end

    ::TilesetTooling::Data::Specs.new(tile_height:, tile_width:, margin:, offset_top:, offset_left:, pattern:, nb_rows:, nb_columns:)
  end

  def save_specs_to_file(specs_file, specs)
    @logger.info("Extracting specs from '#{specs_file}'")
    ::File.open(specs_file, 'w') do |file|
      obj = {
        specs: {
          details: {
            tile_height: specs.tile_height,
            tile_width: specs.tile_width,
            margin: specs.margin,
            offset_top: specs.offset_top,
            offset_left: specs.offset_left
          }
        }
      }

      if @for_new_image
        obj[:specs][:nb_rows] = specs.nb_rows
        obj[:specs][:nb_columns] = specs.nb_columns
        obj[:specs][:pattern] = specs.pattern.to_yaml_string
      end

      ::YAML.dump(obj, file)
    end
  end
end
