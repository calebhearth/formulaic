require 'spec_helper'

describe Formulaic::Label do
  before(:each) do
    class_double("User").as_stubbed_const
    allow(User).to receive(:human_attribute_name).and_return("Human Attribute Name")
  end

  it 'returns the string if there are no translations and it can not human_attribute_name the class' do
    expect(label(nil, 'My label')).to eq 'My label'
  end

  it 'returns human_attribute_name if available' do
    expect(label(:user, :attribute)).to eq 'Human Attribute Name'
  end

  it 'uses a translation if available' do
    I18n.backend.store_translations(:en, { simple_form: { labels: { user: { name: 'Translated' } } } } )

    expect(label(:user, :name)).to eq('Translated')
  end

  it 'should leave cases alone' do
    expect(label(:user, 'Work URL')).to eq 'Work URL'
  end

  def label(model_name, attribute, action = :new)
    Formulaic::Label.new(model_name, attribute, action).to_str
  end
end
