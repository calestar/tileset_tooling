# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'test_helper'

class ::TestUtils < ::Test::Unit::TestCase
  def test_image_signature
    input, = get_png_data('simple_no_margin.png')
    signature = image_signature(input)
    assert_equal('7a61e5c691289afc9d6eb50b52ac7cac05241271775d20233e07ec431e24c9c7', signature)
  end
end
