module Formulaic
  module Inputs
    class DateInput < Input
      def fill
        select_date(value, from: label)
      end

      private

      def select_date(date, options)
        field = find_field(options[:from].to_s)["id"].gsub(/_\di/, "")
        select date.year.to_s, from: "#{field}_1i"
        select I18n.t("date.month_names")[date.month], from: "#{field}_2i"
        select date.day.to_s, from: "#{field}_3i"
      end
    end
  end
end
