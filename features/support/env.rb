# Copyright (c) 2020 Jean-Sebastien Gelinas, see LICENSE.txt
# frozen_string_literal: true

require 'aruba/cucumber'

BIN_DIR = ::File.join(__dir__, '..', '..', 'bin')
LIB_DIR = ::File.join(__dir__, '..', '..', 'lib')
::ENV['PATH'] = "#{::File.expand_path(::BIN_DIR)}#{::File::PATH_SEPARATOR}#{::ENV['PATH']}"

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ::ENV['RUBYLIB']
  ::ENV['RUBYLIB'] = ::LIB_DIR + ::File::PATH_SEPARATOR + ::ENV['RUBYLIB'].to_s
end

After do
  ::ENV['RUBYLIB'] = @original_rubylib
end
