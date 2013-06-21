module Formulaic
  module Inputs
    class ArrayInput < Input
      def fill
        value.each { |checkbox| check checkbox }
      end
    end
  end
end
