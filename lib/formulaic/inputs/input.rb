require 'i18n'
require 'capybara/dsl'

module Formulaic
  module Inputs
    class Input
      include Capybara::DSL

      def initialize(model_name, field, value)
        @model_name = model_name
        @field = field
        @value = value
      end

      private

      def input(model_class, field, action = :create)
        Label.new(model_class, field, action).to_str
      end

      attr_accessor :model_name, :field, :value
    end
  end
end
