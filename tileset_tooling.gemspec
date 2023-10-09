# frozen_string_literal: true

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'tileset_tooling', 'version.rb'])

Gem::Specification.new do |s|
  s.name = 'tileset_tooling'
  s.version = TilesetTooling::VERSION
  s.author = 'Jean-Sebastien Gelinas'
  s.email = 'calestar@gmail.com'
  s.homepage = 'https://github.com/calestar/tileset_tooling'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.2.2'
  s.summary = 'Bits of tooling I use for working with tilesets'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc', 'tileset_tooling.rdoc']
  s.rdoc_options << '--title' << 'tileset_tooling' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'tileset_tooling'
  s.add_development_dependency('aruba', '~> 2.2', '>= 2.2.0')
  s.add_development_dependency('mocha', '~> 2.1', '>= 2.1.0')
  s.add_development_dependency('rake', '~> 13.0', '>= 13.0.6')
  s.add_development_dependency('rdoc', '~> 6.5', '>= 6.5.0')
  s.add_development_dependency('rubocop', '~> 1.56', '>= 1.56.4')
  s.add_development_dependency('rubocop-rake', '~> 0.6', '>= 0.6.0')
  s.add_development_dependency('test-unit', '~> 3.5', '>= 3.5.7')
  s.add_runtime_dependency('dry-struct', '~> 1.6', '>= 1.6.0')
  s.add_runtime_dependency('gli', '~> 2.21', '2.21.1')
  s.add_runtime_dependency('highline', '~> 2.1', '>= 2.1.0')
  s.add_runtime_dependency('mini_magick', '~> 4.12', '>= 4.12.0')
  s.add_runtime_dependency('semantic_logger', '~> 4.14', '>= 4.14.0')
end
