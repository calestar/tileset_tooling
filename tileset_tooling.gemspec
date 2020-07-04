# frozen_string_literal: true

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'tileset_tooling', 'version.rb'])

Gem::Specification.new do |s|
  s.name = 'tileset_tooling'
  s.version = TilesetTooling::VERSION
  s.author = 'Jean-Sebastien Gelinas'
  s.email = 'calestar@gmail.com'
  s.homepage = 'https://github.com/calestar/tileset_tooling'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Bits of tooling I use for working with tilesets'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc', 'tileset_tooling.rdoc']
  s.rdoc_options << '--title' << 'tileset_tooling' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'tileset_tooling'
  s.add_development_dependency('aruba')
  s.add_development_dependency('rake', '>= 12.3.3')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('test-unit')
  s.add_runtime_dependency('gli', '2.19.2')
  s.add_runtime_dependency('semantic_logger')
end
