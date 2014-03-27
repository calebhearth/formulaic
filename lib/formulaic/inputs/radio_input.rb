module Formulaic
  module Inputs
    class RadioInput < Input
      def fill
        pick_radio_button(option_text) || pick_radio_button(value)
      end

      def pick_radio_button(text)
        choose(text)
      rescue Capybara::ElementNotFound
        false
      end

      def option_text
        i18n_key = [model_name, field, value].join(".")
        I18n.t(i18n_key, scope: "simple_form.options", default: "")
      end
    end
  end
end
