# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

# Class used to find/load specs for a given image
class ::TilesetTooling::Utils::SpecsLoader
  # Constructor, initializes a few internals
  def initialize
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

    [tile_height, tile_width, margin, offset_top, offset_left]
  end

  def load_specs_from_file(file_path)
    @logger.info("Extracting specs from '#{file_path}'")
    specs = ::YAML.load_file(file_path)

    begin
      tile_height = specs['specs']['details']['tile_height']
      tile_width = specs['specs']['details']['tile_width']
      margin = specs['specs']['details']['margin']
      offset_top = specs['specs']['details']['offset_top']
      offset_left = specs['specs']['details']['offset_left']
    rescue ::NoMethodError
      raise(::StandardError, 'Invalid specs file')
    end
    [tile_height, tile_width, margin, offset_top, offset_left]
  end
end
