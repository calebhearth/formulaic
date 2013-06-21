module Formulaic
  module Dsl
    def fill_form(model_name, attributes)
      Form.new(model_name, attributes).fill
    end
  end
end
