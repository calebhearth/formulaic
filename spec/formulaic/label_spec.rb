require "spec_helper"

describe Formulaic::Label do
  context "attribute is a string" do
    it "returns the string" do
      expect(label(nil, "My label")).to eq "My label"
    end
  end

  context "attribute is not a string" do
    context "human_attribute_name is available" do
      it "returns human_attribute_name" do
        expect(label(:user, :first_name)).to eq "First name"
      end
    end

    context "translation is available" do
      it "uses a translation" do
        I18n.backend.store_translations(:en, { simple_form: { labels: { user: { name: "Translated" } } } } )

        expect(label(:user, :name)).to eq("Translated")
      end

      context "model is not found" do
        it "uses the attribute as a string" do
          expect(label(:student, "Course selection")).to eq "Course selection"
        end
      end
    end
  end

  it "should leave cases alone" do
    expect(label(:user, "Work URL")).to eq "Work URL"
  end

  def label(model_name, attribute, action = :new)
    Formulaic::Label.new(model_name, attribute, action).to_str
  end
end
