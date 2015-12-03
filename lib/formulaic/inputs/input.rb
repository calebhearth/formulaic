require 'i18n'
require 'capybara/dsl'

module Formulaic
  module Inputs
    class Input
      include Capybara::DSL

      def initialize(label, value)
        @label = label
        @value = value
      end

      private

      attr_accessor :label, :value
    end
  end
end
