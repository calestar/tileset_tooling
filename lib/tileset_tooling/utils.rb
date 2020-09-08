# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'mini_magick'

# A few random utilities
module ::TilesetTooling::Utils
  module_function

  # Generate a signature from the image data
  def image_signature(image_path)
    ::MiniMagick::Tool::Identify.new do |identity|
      identity.quiet
      identity.format('%#\\n')
      identity << image_path
    end
  end

  # Gets the path to the spec file that should go with the given image
  def image_spec_file_path(image_path)
    file_name = ::File.basename(image_path, '.*')
    directory = ::File.dirname(image_path)

    "#{directory}/#{file_name}.specs"
  end
end
