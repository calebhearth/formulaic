module Formulaic
  module Inputs
    class CheckboxInput < ArrayInput
      def fill
        if has_check_boxes?
          check_boxes
          true
        else
          false
        end
      end

      private

      def has_check_boxes?
        contains_all_options?(checkbox_labels)
      end

      def check_boxes
        value.each { |checkbox| check checkbox }
      end

      def checkbox_labels
        all(checkbox_labels_selector)
      end

      def checkbox_name_selector
        "input[type='checkbox'][name='#{label.model_name}[#{label.attribute}][]']"
      end

      def checkbox_name_selector_for_association
        "input[type='checkbox'][name='#{label.model_name}[#{label.attribute.to_s.singularize}_ids][]']"
      end

      def checkbox_labels_selector
        [
          "#{checkbox_name_selector} ~ label",
          "label:has(#{checkbox_name_selector})",
          "#{checkbox_name_selector_for_association} ~ label",
          "label:has(#{checkbox_name_selector_for_association})",
        ].join(",")
      end
    end
  end
end
