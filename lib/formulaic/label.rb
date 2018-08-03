module Formulaic
  class Label
    attr_reader :model_name, :attribute, :action

    def self.translation_scopes
      Set.new([
        [:simple_form, :labels],
        [:simple_form, :labels, :defaults],
      ])
    end

    def initialize(model_name, attribute, action)
      @model_name = model_name
      @attribute = attribute
      @action = action
    end

    def to_str
      if attribute.is_a?(String)
        attribute
      else
        translated || human_attribute_name || attribute.to_s.humanize
      end
    end
    alias_method :to_s, :to_str

    private

    def translated
      Formulaic.translation_scopes.reduce(nil) do |translation, scope|
        translation ||
          translate([model_name, action, attribute], scope) ||
          translate([model_name, attribute], scope) ||
          translate(attribute, scope)
      end
    end

    def translate(keys, scope)
      key = Array(keys).join(".")

      I18n.translate(key, scope: scope, default: nil).presence
    end

    def human_attribute_name
      if class_exists?(model_name.to_s.classify)
        model_class = model_name.to_s.classify.constantize
        if model_class.respond_to?(:human_attribute_name)
          model_class.human_attribute_name(attribute.to_s)
        end
      end
    end

    def class_exists?(class_name)
      Object.const_defined?(class_name.to_s.classify)
    rescue NameError
      false
    end
  end
end
