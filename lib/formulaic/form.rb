require 'active_support/time_with_zone'

module Formulaic
  class Form
    ATTRIBUTE_INPUT_MAP = {
      ActiveSupport::TimeWithZone => Formulaic::Inputs::DateInput,
      Date => Formulaic::Inputs::DateInput,
      Array => Formulaic::Inputs::ArrayInput,
      String => Formulaic::Inputs::StringInput,
      TrueClass => Formulaic::Inputs::BooleanInput,
      FalseClass => Formulaic::Inputs::BooleanInput,
    }.freeze

    def initialize(model_name, attributes)
      @inputs = build_inputs(model_name, attributes)
      @session = session
    end

    def fill
      @inputs.each { |input| input.fill }
    end

    private

    attr_reader :session, :model_name, :inputs

    def build_inputs(model_name, attributes)
      attributes.map do |field, value|
        build_input(model_name, field, value)
      end
    end

    def build_input(model_name, field, value)
      ATTRIBUTE_INPUT_MAP[value.class].new(model_name, field, value)
    end
  end
end
