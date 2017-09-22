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

      expect(label(:user, :name)).to eq("Translated")
    end
  end

  context "when helpers.label.<model> translations are available" do
    it "uses helpers.label translation" do
      store_translations(
        helpers: {
          label: {
            user: {
              name: "Translated"
            },
          },
        },
      )

      expect(label(:user, :name)).to eq("Translated")
    end
  end

  context "when helpers.label.text default translations are available" do
    it "uses helpers.label.text translations" do
      store_translations(
        helpers: {
          label: {
            text: "Default",
          },
        },
      )

      expect(label(:user, :name)).to eq("Default")
    end
  end

  context "when activerecord.attributes.<model> translations are available" do
    it "uses activerecord.attributes translations" do
      store_translations(
        activerecord: {
          attributes: {
            user: {
              name: "Translated"
            },
          },
        },
      )

      expect(label(:user, :name)).to eq("Translated")
    end
  end

  it "should leave cases alone" do
    expect(label(:user, "Work URL")).to eq "Work URL"
  end

  it "uses the attribute when the model is not found" do
    expect(label(:student, "Course selection")).to eq "Course selection"
  end

  it "humanizes attribute if no translation is found and human_attribute_name is not available" do
    expect(label(:student, :course_selection)).to eq "Course selection"
  end

  def store_translations(translations)
      I18n.reload!
      I18n.backend.store_translations(:en, translations)
  end

  def label(model_name, attribute, action = :new)
    Formulaic::Label.new(model_name, attribute, action).to_str
  end
end
