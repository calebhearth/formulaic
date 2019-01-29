module Formulaic
  module Inputs
    class ArrayInput < Input
      def fill
        attempt_to_fill_selects ||
          attempt_to_fill_checkboxes ||
          raise_input_error
      end

      private

      def attempt_to_fill_selects
        SelectInput.new(label, value).fill
      end

      def attempt_to_fill_checkboxes
        CheckboxInput.new(label, value).fill
      end

      def contains_all_options?(nodes)
        nodes.map(&:text).to_set.superset?(value.to_set)
      end

      def raise_input_error
        raise(
          InputNotFound,
          %[Unable to find checkboxes or select[multiple] "#{label}" containing all options #{value.inspect}.]
        )
      end
    end
  end
end

require 'formulaic/inputs/checkbox_input'
require 'formulaic/inputs/select_input'
