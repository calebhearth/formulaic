require "spec_helper"

describe Formulaic::Label do
  context "attribute is a string" do
    it "returns the string" do
      expect(label(nil, "My label")).to eq "My label"
    end
  end

  context "attribute is not a string" do
    context "translation is available" do
      context "no presenter provided" do
        it "uses a translation" do
          create_translation_for({ user: { name: "First name"}})

          expect(label(:user, :name)).to eq("First name")
        end
      end

      context "presenter provided" do
        it "uses a translation" do
          create_translation_for({ user: { name: { presenter: "First name"}}})

          expect(label(:user, :name, presenter: :presenter)).to eq("First name")
        end
      end
    end

    context "translation is not available" do
      context "human_attribute_name is available" do
        it "returns human_attribute_name" do
          create_translation_for({ user: { name: nil}})

          expect(label(:user, :name)).to eq "Name"
        end
      end

      context "model is not found" do
        it "uses the attribute as a string" do
          create_translation_for({ student: nil })

          expect(label(:student, "Course_selection")).to eq "Course_selection"
        end
      end
    end
  end

  def label(model_name, attribute, action = :new, presenter: :nil)
    Formulaic::Label.new(model_name, attribute, action, presenter).to_str
  end

  def create_translation_for(label)
    I18n.backend.store_translations(
      :en, { simple_form: { labels: label } }
    )
  end
end
