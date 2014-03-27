module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        if page.has_selector?(:fillable_field, input_text)
          fill_in(input_text, with: value)
        elsif is_radio_button?
          RadioInput.new(model_name, field, value).fill
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

      private

      def is_radio_button?
        radio_button_id = [model_name, field, value].join('_')

        page.has_selector?(:radio_button, input_text) ||
        page.has_selector?(:radio_button, radio_button_id)
      end
    end
  end
end
