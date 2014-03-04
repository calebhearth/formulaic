module Formulaic
  module Inputs
    class ArrayInput < Input
      def fill
        value.each { |checkbox| check checkbox }
      end

      def current_value
        value.all? { |chckbox| find(checkbox).checked? }
      end
    end
  end
end
