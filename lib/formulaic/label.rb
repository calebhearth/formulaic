module Formulaic
  class Label
    def initialize(model_name, attribute, action = :create)
      @model_name = model_name
      @attribute = attribute
      @action = action
    end

    def to_str
      if attribute.is_a?(String)
        attribute
      else
        translate('placeholders') || translate('labels') ||
          human_attribute_name || attribute.to_s
      end
    end
    alias_method :to_s, :to_str

    private

    attr_reader :model_name, :attribute, :action

    def translate(key = 'labels')
      I18n.t(lookup_paths.first, scope: :"simple_form.#{key}", default: lookup_paths).presence
    end

    def human_attribute_name
      if class_exists?(model_name.to_s.classify)
        model_class = model_name.to_s.classify.constantize
        if model_class.respond_to?(:human_attribute_name)
          model_class.human_attribute_name(attribute.to_s)
        end
      end
    end

    def lookup_paths
      [
        :"#{model_name}.#{action}.#{attribute}",
        :"#{model_name}.#{attribute}",
        :"defaults.#{action}.#{attribute}",
        :"defaults.#{attribute}",
        '',
      ]
    end

    def class_exists?(class_name)
      Object.const_defined?(model_name.to_s.classify)
    rescue NameError
      false
    end
  end
end
