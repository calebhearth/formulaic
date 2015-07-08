require 'spec_helper'

describe Formulaic::Dsl do
  describe 'input' do
    it 'builds a label' do
      label = instance_double('Formulaic::Label')
      allow(label).to receive(:to_str)
      allow(Formulaic::Label).to receive(:new).and_return(label)

      object_with_dsl.input :model, :attribute, :action

      expect(Formulaic::Label).to have_received(:new)
        .with(:model, :attribute, :action)
      expect(label).to have_received(:to_str)
    end

    it 'defaults action to :new' do
      allow(Formulaic::Label).to receive(:new).and_return(double(to_str: nil))

      object_with_dsl.input :model, :attribute

      expect(Formulaic::Label).to have_received(:new)
        .with(:model, :attribute, :new)
    end

  end

  describe 'fill_form' do
    it 'creates a form and fills it' do
      form = instance_double('Formulaic::Form')
      allow(form).to receive(:fill)
      allow(Formulaic::Form).to receive(:new).and_return(form)

      object_with_dsl.fill_form :model, :action, attributes: :values

      expect(Formulaic::Form).to have_received(:new)
        .with(:model, :action, attributes: :values)
      expect(form).to have_received(:fill)
    end

    it 'assumes that action = :new' do
      allow(Formulaic::Form).to receive(:new).and_return(double(fill: nil))

      object_with_dsl.fill_form :model, attributes: :values

      expect(Formulaic::Form).to have_received(:new)
        .with(:model, :new, attributes: :values)
    end
  end

  describe 'submit' do
    it 'finds a custom submit label' do
      I18n.backend.store_translations(:en, { helpers: { submit: { user: { create: 'Create user' } } } })

      expect(object_with_dsl.submit(:user)).to eq 'Create user'

      I18n.backend.store_translations(:en, { helpers: { submit: { user: { create: nil } } } })
    end

    it 'finds the default submit label' do
      expect(object_with_dsl.submit(:user)).to eq 'Create User'
    end
  end

  describe 'fill_form_and_submit' do
    it 'fills a form and submits it' do
      I18n.backend.store_translations(:en, { helpers: { submit: { model: { create: 'Create model' } } } })
      allow(Formulaic::Form).to receive(:new).and_return(double(fill: nil))
      allow(object_with_dsl).to receive(:click_on)

      object_with_dsl.fill_form_and_submit :model, attributes: :values

      expect(Formulaic::Form).to have_received(:new)
        .with(:model, :new, attributes: :values)
      expect(object_with_dsl).to have_received(:click_on).with('Create model')

      I18n.backend.store_translations(:en, { helpers: { submit: { model: { create: nil } } } })
    end
  end

  def object_with_dsl
    @object_with_dsl ||= Class.new do
      include Formulaic::Dsl
    end.new
  end
end
