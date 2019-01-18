# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'xcpretty-junit-formatter'
  spec.version       = '0.1.1'
  spec.authors       = ['Sascha Held']
  spec.email         = ['saschaheld@me.com']

  spec.summary       = 'xcpretty custom formatter for JUNIT output'
  spec.description   = 'Custom formatter for xcpretty that saves on a JUNIT file that contains all the errors, warnings and test failures, so you can process them easily later.'
  spec.homepage      = 'https://github.com/faken/xcpretty-junit-formatter'
  spec.license       = 'MIT'

  spec.files         = [
    'README.md',
    'LICENSE',
    'lib/junit_formatter.rb',
    'bin/xcpretty-junit-formatter'
  ]
  spec.executables   = ['xcpretty-junit-formatter']
  spec.require_paths = ['lib']

  spec.add_dependency 'xcpretty', '~> 0.2', '>= 0.0.7'
  spec.add_runtime_dependency 'xml-simple', '~> 1.1', '>= 1.1.5'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
end
