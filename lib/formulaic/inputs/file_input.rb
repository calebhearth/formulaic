module Formulaic
  module Inputs
    class FileInput < Input
      def fill
        attach_file(label, value.path)
      end
    end
  end
end
