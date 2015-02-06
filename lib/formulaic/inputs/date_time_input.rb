module Formulaic
  module Inputs
    class DateTimeInput < DateInput
      def fill
        select_date(value, from: label)
      end

      private

      def select_date(date_time, options)
        super
        field = find_field(options[:from].to_s)["id"].gsub(/_\di/, "")
        select date_time.hour.to_s, from: "#{field}_4i"
        select date_time.minute.to_s, from: "#{field}_5i"
      end
    end
  end
end
