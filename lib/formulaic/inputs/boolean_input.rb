module Formulaic
  module Inputs
    class BooleanInput < Input
      def fill
        if value
          check(input(model_name, field))
        else
          uncheck(input(model_name, field))
        end
      end
    end
  end
end
