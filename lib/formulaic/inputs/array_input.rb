module Formulaic
  module Inputs
    class ArrayInput < Input
      def fill
        if page.has_select?(label)
          value.each { |option| select option, from: label }
        else
          value.each { |checkbox| check checkbox }
        end
      end
    end
  end
end
