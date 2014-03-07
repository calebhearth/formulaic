module Formulaic
  module Inputs
    class DateInput < Input
      def fill
        select_date(value, from: date_input.label)
      rescue
        select_date(value, id: date_input.id)
      end

      private

      def date_input
        input(model_name, field)
      end

      def select_date(date, options)
        id    = options[:id] || find_field(options[:from].to_s)["id"]
        field = id.gsub(/_1i/, "")
        select date.year.to_s, from: "#{field}_1i"
        select Date::MONTHNAMES[date.month], from: "#{field}_2i"
        select date.day.to_s, from: "#{field}_3i"
      end
    end
  end
end
