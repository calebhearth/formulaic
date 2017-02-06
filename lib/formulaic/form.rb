require 'active_support/time_with_zone'

module Formulaic
  class Form
    ATTRIBUTE_INPUT_MAP = {
      ActiveSupport::TimeWithZone => Formulaic::Inputs::DateInput,
      Date => Formulaic::Inputs::DateInput,
      DateTime => Formulaic::Inputs::DateTimeInput,
      Array => Formulaic::Inputs::ArrayInput,
      String => Formulaic::Inputs::StringInput,
      Symbol => Formulaic::Inputs::StringInput,
      1.class => Formulaic::Inputs::StringInput,
      Float => Formulaic::Inputs::StringInput,
      TrueClass => Formulaic::Inputs::BooleanInput,
      FalseClass => Formulaic::Inputs::BooleanInput,
      File => Formulaic::Inputs::FileInput,
    }.freeze

    def initialize(model_name, action, attributes)
      @action = action
      @inputs = build_inputs(model_name, attributes)
    end

    def fill
      @inputs.each { |input| input.fill }
    end

    private

    attr_reader :model_name, :inputs, :action

    def build_inputs(model_name, attributes)
      attributes.map do |field, value|
        build_input(model_name, field, value)
      end
    end

    def build_input(model_name, field, value)
      label = Label.new(model_name, field, action)
      input_class_for(value).new(label, value)
    end

    def input_class_for(value)
      ATTRIBUTE_INPUT_MAP.fetch(value.class) do
        raise InvalidAttributeTypeError.new("Formulaic does not know how to fill in a #{value.class} value")
      end
    end

    class InvalidAttributeTypeError < StandardError; end
  end
end
