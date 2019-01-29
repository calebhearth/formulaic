# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formulaic/version'

Gem::Specification.new do |spec|
  spec.name          = 'formulaic'
  spec.version       = Formulaic::VERSION
  spec.authors       = ['Caleb Thompson']
  spec.email         = ['caleb@calebthompson.io']
  spec.summary       = 'Simplify form filling with Capybara'
  spec.description   = <<-DESCRIPTION.sub(/^ +/, '')
    Removes the tedium of formulaic form filling with Capybara by allowing you
    to specify a hash of attributes to be input rather than procedurally calling
    Capybara’s DSL methods.
  DESCRIPTION
  spec.homepage      = 'https://github.com/thoughtbot/formulaic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capybara'
  spec.add_dependency 'i18n'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
