require 'spec_helper'

describe Formulaic::Dsl do
  it 'responds to input' do
    expect(object_with_dsl).to respond_to(:input)
  end

  it 'responds to fill_form' do
    expect(object_with_dsl).to respond_to(:fill_form)
  end

  it 'finds a submit label' do
    I18n.backend.store_translations(:en, { helpers: { submit: { user: { create: 'Create user' } } } })

    expect(object_with_dsl.submit(:user)).to eq 'Create user'
  end

  def object_with_dsl
    @object_with_dsl ||= Class.new do
      include Formulaic::Dsl
    end.new
  end
end
