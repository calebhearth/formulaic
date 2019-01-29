module Formulaic
  module Inputs
    class BooleanInput < Input
      def fill
        if value
          check(label.to_str)
        else
          uncheck(label.to_str)
        end
      end
    end
  end
end
