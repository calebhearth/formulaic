require 'formulaic'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

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

  def reset_and_load_translations
    I18n.reload!
    I18n.backend.store_translations(:en, YAML.load(<<-TRANSLATIONS))
        helpers:
          submit:
            create: 'Create %{model}'
            update: 'Update %{model}'
            submit: 'Save %{model}'
        simple_form:
          labels:
            user:
              age: Your Age
              avatar: Your Avatar
              awesome: Are you awesome?
              bio: Biography
              date_of_birth: Your Date of birth
              likes: Your Likes
              dislikes: Your Dislikes
              email: Your Email
              name: Your Display name
              new:
                password: Your Password
                phone: Phone Number
                terms_of_service: I agree to the Terms of Service
                url: Website
          options:
            user:
              role:
                admin: Administrator
                member: Member
    TRANSLATIONS
    I18n.backend.store_translations(:es, YAML.load(<<-TRANSLATIONS))
      date:
        month_names:
          -
          - Enero
          - Febrero
          - Marzo
          - Abril
          - Mayo
          - Junio
          - Julio
          - Agosto
          - Septiembre
          - Octubre
          - Noviembre
          - Diciembre
    TRANSLATIONS
  end
end

RSpec.configure do |config|
  config.include SpecHelper

  config.before(:each) do
    reset_and_load_translations
  end
end
