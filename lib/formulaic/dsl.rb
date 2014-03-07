module Formulaic
  module Dsl
    def fill_form(model_name, attributes)
      Form.new(model_name, attributes).fill
    end

    def input(model_name, field, action = :create)
      Label.new(model_name, field, action).to_str
    end

    def submit(model_class, action = :create)
      I18n.t([:helpers, :submit, model_class, action].join('.'))
    end
  end
end
