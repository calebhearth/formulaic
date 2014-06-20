require 'spec_helper'

describe Formulaic::Label do
  before { I18n.reload! }

  context 'when a label translation is available' do
    it 'uses a label translation' do
      I18n.backend.store_translations(:en, { simple_form: { labels: { user: { name: 'Translated' } } } } )

      expect(label(:user, :name)).to eq('Translated')
    end
  end

  context 'when a placeholder translation is available' do
    it 'uses a placeholder translation' do
      I18n.backend.store_translations(:en, { simple_form: { placeholders: { user: { name: 'Translated' } } } } )

      expect(label(:user, :name)).to eq('Translated')
    end
  end

  it 'returns the string if there are no translations and it can not human_attribute_name the class' do
    expect(label(nil, 'My label')).to eq 'My label'
  end

  it 'returns human_attribute_name if available' do
    expect(label(:user, :attribute)).to eq 'Human Attribute Name'
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
