module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        fill_with(:label)
      rescue
        fill_with(:id)
      end

      def input_text
        input_element.to_str
      end

      def has_option_in_select?(option, select)
        find(:select, select).has_selector?(:option, option)
      rescue Capybara::ElementNotFound
        false
      end

      private

      def input_element
        @input_element ||= element(model_name, field)
      end

      def fill_with(method = :label)
        lookup = input_element.__send__(method)
        if page.has_selector?(:fillable_field, lookup)
          fill_in(lookup, with: value)
        elsif page.has_selector?(:radio_button, lookup)
          choose(value)
        elsif has_option_in_select?(value, lookup)
          select(value, from: lookup)
        else
          raise Formulaic::InputNotFound.new(%[Unable to find input "#{lookup}".])
        end
      end
    end
  end
end
