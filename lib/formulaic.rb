require 'active_support/core_ext/string/inflections'
require 'formulaic/version'
require 'formulaic/errors'
require 'formulaic/label'
require 'formulaic/inputs'
require 'formulaic/form'
require 'formulaic/dsl'

module Formulaic
  class << self
    attr_accessor :default_wait_time

    def configure
      yield self
    end
  end
end

Formulaic.configure do |config|
  config.default_wait_time = 0
end
