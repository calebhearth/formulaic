require 'formulaic'
require 'pry'

I18n.enforce_available_locales = true

module SpecHelper
  def input(model, field)
    page.find("##{model}_#{field}")
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
    TRANSLATIONS
  end
end

RSpec.configure do |c|
  c.include SpecHelper
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
