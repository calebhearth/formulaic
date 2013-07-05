require 'spec_helper'

describe Formulaic::Label do
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

  def label(model_name, attribute, action = :create)
    Formulaic::Label.new(model_name, attribute, action).to_str
  end
end

class User
  def self.human_attribute_name(*)
    'Human Attribute Name'
  end
end
