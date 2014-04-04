module Formulaic
  module Inputs
    class FileInput < Input
      def fill
        attach_file(label, value.path)
      end

      private

      def label
        input(model_name, field)
      end
    end
  end
end
