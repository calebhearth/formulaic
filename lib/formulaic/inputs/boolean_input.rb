module Formulaic
  module Inputs
    class BooleanInput < Input
      def fill
        fill_with(:label)
      rescue
        fill_with(:id)
      end

      private

      def fill_with(method = :label)
        if value
          check(checkbox.__send__(method))
        else
          uncheck(checkbox.__send__(method))
        end
      end

      def checkbox
        input(model_name, field)
      end
    end
  end
end
