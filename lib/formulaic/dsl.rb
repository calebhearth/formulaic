module Formulaic
  module Dsl
    def fill_form(model_name, attributes)
      Form.new(model_name, attributes).fill
    end

    def input(model_name, field, action = :create)
      Label.new(model_name, field, action).to_str
    end
  end
end
