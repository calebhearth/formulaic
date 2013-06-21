module Formulaic
  module Inputs
    class DateInput < Input
      def fill
        select_date(value, from: input(model_name, field))
      end

      private

      def select_date(date, options)
        field = find_field(options[:from].to_s)["id"].gsub(/_1i/, "")
        select date.year.to_s, from: "#{field}_1i"
        select Date::MONTHNAMES[date.month], from: "#{field}_2i"
        select date.day.to_s, from: "#{field}_3i"
      end
    end
  end
end
