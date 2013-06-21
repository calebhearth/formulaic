module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        fill_in(input(model_name, field), with: value)
      end
    end
  end
end
