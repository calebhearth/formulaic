module Formulaic
  module Inputs
    class FileInput < Input
      def fill
        attach_file(label.to_str, value.path)
      end
    end
  end
end
