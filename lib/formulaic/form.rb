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

    def fill_field(model_name, field, value)
      if value.is_a? Hash
        value.each { |subfield, subvalue| fill_field(field, subfield, subvalue) }
      else
        send(field_method(value), model_name, field, value)
      end
    end

    private

    attr_reader :session, :model_name, :inputs

    def build_inputs(model_name, attributes)
      attributes.map do |field, value|
        if value.is_a?(Hash)
          value.map { |nested_field, nested_value| build_input(field, nested_field, nested_value) }
        else
          build_input(model_name, field, value)
        end
      end.flatten
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
