require 'formulaic'
require 'pry'

module SpecHelper
  def input(model, field, value = nil)
    ids = [model, field]
    unless value.nil?
      ids.push(value)
    end

    id = ids.join("_")

    page.find("##{id}")
  end

  def visit(page_name)
    page.visit("/#{page_name}.html")
  end

  def page
    @page ||= begin
                Capybara.app = Rack::File.new(File.expand_path('../fixtures', __FILE__))
                Capybara.current_session
              end
  end

  def load_translations
    I18n.backend.store_translations(:en, YAML.load(<<-TRANSLATIONS))
        simple_form:
          labels:
            user:
              age: Age
              name: Display name
              email: Email
              phone: Phone Number
              url: Website
              password: Password
              date_of_birth: Date of birth
              terms_of_service: I agree to the Terms of Service
              awesome: Are you awesome?
              bio: Biography
          options:
            user:
              gender:
                male: Male
                female: Female
    TRANSLATIONS
  end
end

RSpec.configure do |c|
  c.include SpecHelper
end
