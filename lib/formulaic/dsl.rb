module Formulaic
  module Dsl
    def fill_form(model_name, action = :new, attributes)
      Form.new(model_name, action, attributes).fill
    end

    def input(model_name, field, action = :new)
      Label.new(model_name, field, action).to_str
    end

    def submit(model_class, action = :create)
      I18n.t([:helpers, :submit, model_class, action].join('.'))
    end
  end
end
