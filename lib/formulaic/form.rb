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
      @model_name = model_name
      @inputs = build_inputs(@model_name, attributes)
      @session = session
    end

    def fill
      @inputs.each { |input| input.fill }
    end

    def matches?(attributes = {})
      attributes.all? do |field, value|
        build_input(@model_name, field, value).current_value == value
      end
    end
    alias :match? :matches?

    private

    attr_reader :session, :model_name, :inputs

    def build_inputs(model_name, attributes)
      attributes.map do |field, value|
        build_input(model_name, field, value)
      end
    end

    def build_input(model_name, field, value)
      input_class_for(value).new(model_name, field, value)
    end

    def input_class_for(value)
      ATTRIBUTE_INPUT_MAP.fetch(value.class) do
        raise InvalidAttributeTypeError.new("Formulaic does not know how to fill in a #{value.class} value")
      end
    end

    class InvalidAttributeTypeError < StandardError; end
  end
end
