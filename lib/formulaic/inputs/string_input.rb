module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        if page.has_selector?(:fillable_field, label.to_str, wait: Formulaic.default_wait_time)
          fill_in(label.to_str, with: value)
        elsif page.has_selector?(:radio_button, label.to_str, wait: Formulaic.default_wait_time)
          choose(value)
        elsif has_option_in_select?(translate_option(value), label.to_str)
          select(translate_option(value), from: label.to_str)
        else
          raise Formulaic::InputNotFound.new(%[Unable to find input "#{label}".])
        end
      end

      def has_option_in_select?(option, select)
        element = find(:select, select.to_str)
        if ! element.has_selector?(:option, option, wait: Formulaic.default_wait_time)
          raise Formulaic::OptionForSelectInputNotFound.new(%[Unable to find option with text matching "#{option}".])
        end
        true
      rescue Capybara::ElementNotFound
        false
      end

      private

      def translate_option(option)
        I18n.t(lookup_paths_for_option.first,
               scope: :'simple_form.options', default: lookup_paths_for_option)
      end

      def lookup_paths_for_option
        [
          :"#{label.model_name}.#{label.attribute}.#{value}",
          :"defaults.#{label.attribute}.#{value}",
          value.to_s,
        ]
      end
    end
  end
end
