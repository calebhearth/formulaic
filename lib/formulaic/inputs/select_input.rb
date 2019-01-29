module Formulaic
  module Inputs
    class SelectInput < ArrayInput
      def fill
        if has_multiple_select?
          select_options
          true
        else
          false
        end
      end

      private

      def select_options
        value.each { |option| select option, from: label.to_str }
      end

      def has_multiple_select?
        has_select? && select_is_multiple?
      end

      def has_select?
        has_field?(label.to_str, type: "select")
      end

      def select_is_multiple?
        select_element[:multiple].present? &&
          contains_all_options?(select_element.all("option"))
      end

      def select_element
        @select_element ||= find_field(label.to_str, type: "select")
      end
    end
  end
end
