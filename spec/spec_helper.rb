require 'formulaic'

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
              avatar: Avatar
              awesome: Are you awesome?
              bio: Biography
              date_of_birth: Date of birth
              likes: Likes
              dislikes: Dislikes
              email: Email
              name: Display name
              new:
                password: Password
                phone: Phone Number
                terms_of_service: I agree to the Terms of Service
                url: Website
    TRANSLATIONS
  end
end

RSpec.configure do |c|
  c.include SpecHelper
end
