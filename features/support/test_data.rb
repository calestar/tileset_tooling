# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

def test_data_path(name)
  "#{__dir__}/../../test/data/#{name}"
end

def test_result_path(name)
  "#{__dir__}/../../test/data/expected/#{name}"
end
