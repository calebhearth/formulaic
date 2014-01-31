module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        if page.has_selector?(:fillable_field, input_text)
          fill_in(input_text, with: value)
        elsif page.has_selector?(:radio_button, input_text)
          choose(value)
        elsif has_option_in_select?(value, input_text)
          select(value, from: input_text)
        else
          raise Formulaic::InputNotFound.new(%[Unable to find input "#{input_text}".])
        end
      end

      def input_text
        @input_text ||= input(model_name, field)
      end

      def has_option_in_select?(option, select)
        find(:select, select).has_selector?(:option, option)
      rescue Capybara::ElementNotFound
        false
      end
    end
  end
end
