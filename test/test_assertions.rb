# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

def assert_signature_of(output, expected)
  assert ::File.exist?(expected)
  assert ::File.exist?(output)
  output_signature = ::TilesetTooling::Utils.image_signature(output)
  expected_signature = ::TilesetTooling::Utils.image_signature(expected)
  assert_equal(expected_signature, output_signature)
end
