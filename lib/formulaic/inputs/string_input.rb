module Formulaic
  module Inputs
    class StringInput < Input
      def fill
        if page.has_selector?(:fillable_field, input_text)
          fill_in(input_text, with: value)
        elsif page.has_field?(input_text, type: 'radio')
          choose(value)
        else
          select(value, from: input_text)
        end
      end

      def input_text
        @input_text ||= input(model_name, field)
      end
    end
  end
end
