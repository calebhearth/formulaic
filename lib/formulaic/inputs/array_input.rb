module Formulaic
  module Inputs
    class ArrayInput < Input
      def fill
        if has_select?
          select_options
        else
          check_boxes
        end
      rescue Capybara::ElementNotFound
        raise InputNotFound.new(%[Unable to find input "#{label}".])
      end

      private

      def has_select?
        page.has_select?(label)
      end

      def select_options
        value.each { |option| select option, from: label }
      end

      def check_boxes
        value.each { |checkbox| check checkbox }
      end
    end
  end
end
