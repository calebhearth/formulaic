module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        if page.has_selector?(:fillable_field, label, wait: Formulaic.default_wait_time)
          fill_in(label, with: value)
        elsif page.has_selector?(:radio_button, label, wait: Formulaic.default_wait_time)
          choose(value)
        elsif has_option_in_select?(value, label)
          select(value, from: label)
        else
          raise Formulaic::InputNotFound.new(%[Unable to find input "#{label}".])
        end
      end

      def has_option_in_select?(option, select)
        find(:select, select).has_selector?(:option, option, wait: Formulaic.default_wait_time)
      rescue Capybara::ElementNotFound
        false
      end
    end
  end
end
