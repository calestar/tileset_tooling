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
  s.required_ruby_version = '>= 2.6.3'
  s.summary = 'Bits of tooling I use for working with tilesets'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc', 'tileset_tooling.rdoc']
  s.rdoc_options << '--title' << 'tileset_tooling' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'tileset_tooling'
  s.add_development_dependency('aruba', '~> 1.0', '>= 1.0.3')
  s.add_development_dependency('mocha', '~> 1.11', '>= 1.11.2')
  s.add_development_dependency('rake', '~> 12.3', '>= 12.3.3')
  s.add_development_dependency('rdoc', '~> 6.2', '>= 6.2.1')
  s.add_development_dependency('rubocop', '~> 0.90', '>= 0.90.0')
  s.add_development_dependency('test-unit', '~> 3.3', '>= 3.3.6')
  s.add_runtime_dependency('dry-struct', '~> 1.3', '>= 1.3.0')
  s.add_runtime_dependency('gli', '~> 2.19', '2.19.2')
  s.add_runtime_dependency('highline', '~> 2.0', '>= 2.0.3')
  s.add_runtime_dependency('mini_magick', '~> 4.10', '>= 4.10.1')
  s.add_runtime_dependency('semantic_logger', '~> 4.7', '>= 4.7.2')
end
