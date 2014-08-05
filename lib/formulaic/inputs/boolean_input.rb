module Formulaic
  module Inputs
    class BooleanInput < Input
      def fill
        if value
          check(label)
        else
          uncheck(label)
        end
      end
    end
  end
end
