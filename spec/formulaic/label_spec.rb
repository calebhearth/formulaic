require "spec_helper"

describe Formulaic::Label do
  it "returns the string if there are no translations and it can not human_attribute_name the class" do
    expect(label(nil, "My label")).to eq "My label"
  end

  it "returns human_attribute_name if available" do
    expect(label(:user, :first_name)).to eq "First name"
  end

  context "when simple_form translations are available" do
    it "uses simple_form translation" do
      store_translations(
        simple_form: {
          labels: {
            user: {
              name: "Translated"
            },
          },
        },
      )

      translated = label(:user, :name)

      expect(translated).to eq("Translated")
    end

    it "takes precedent over custom translation scopes" do
      Formulaic.configure do |config|
        config.translation_scopes << "helpers.label"
      end
      simple_form_label = "Translated With Simple Form"
      rails_label = "Translated with Rails"
      store_translations(
        helpers: {
          label: {
            user: {
              name: rails_label,
            },
          },
        },
        simple_form: {
          labels: {
            user: {
              name: simple_form_label,
            },
          },
        },
      )

      translated = label(:user, :name)

      expect(translated).to eq(simple_form_label)
    end
  end

  context "when additional translation scopes are available" do
    it "supports Rails conventions" do
      Formulaic.configure do |config|
        config.translation_scopes << "helpers.label"
      end
      store_translations(
        helpers: {
          label: {
            user: {
              name: "Translated"
            },
          },
        },
      )

      translated = label(:user, :name)

      expect(translated).to eq("Translated")
    end

    it "supports ActiveRecord conventions" do
      Formulaic.configure do |config|
        config.translation_scopes << "activerecord.attributes"
      end
      store_translations(
        activerecord: {
          attributes: {
            user: {
              name: "Translated"
            },
          },
        },
      )

      translated = label(:user, :name)

      expect(translated).to eq("Translated")
    end
  end

  it "should leave cases alone" do
    translated = label(:user, "Work URL")

    expect(translated).to eq "Work URL"
  end

  it "uses the attribute when the model is not found" do
    translated = label(:student, "Course selection")

    expect(translated).to eq "Course selection"
  end

  it "humanizes attribute if no translation is found and human_attribute_name is not available" do
    translated = label(:student, :course_selection)

    expect(translated).to eq "Course selection"
  end

  def store_translations(translations)
      I18n.reload!
      I18n.backend.store_translations(:en, translations)
  end

  def label(model_name, attribute, action = :new)
    Formulaic::Label.new(model_name, attribute, action).to_str
  end
end
