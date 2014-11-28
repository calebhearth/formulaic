module Formulaic
  class Label
    attr_reader :model_name, :attribute, :action

    def initialize(model_name, attribute, action)
      @model_name = model_name.to_s
      @attribute  = attribute
      @action     = action
    end

    def to_str
      send("attribute_#{attribute.class}")
    end
    alias_method :to_s, :to_str

    private

    def attribute_String
      attribute
    end

    def attribute_Symbol
      translate || human_attribute_name || attribute.to_s
    end

    def translate
      I18n.t(lookup_paths.first, scope: :'simple_form.labels', default: lookup_paths).presence
    end

    def human_attribute_name
      Object.const_get(model_name.classify).try(:human_attribute_name, attribute)
    rescue NameError
      nil
    end

    def lookup_paths
      [
        :"#{model_name}.#{action}.#{attribute}",
        :"#{model_name}.#{attribute}",
        :"defaults.#{action}.#{attribute}",
        :"defaults.#{attribute}",
        ''
      ]
    end

  end
end
