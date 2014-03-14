require 'spec_helper'
require 'formulaic/factory_girl'

describe Formulaic::FactoryGirl, :factory_girl do
  before(:all) do
    define_user_factory(user_class)
  end

  after(:all) do
    FactoryGirl.factories.clear
  end

  it 'sets attributes to FactoryGirl.attributes_for(model_name) if attributes is omitted' do
    allow(class_with_dsl).to receive(:fill_form)

    fill_with_factory(:user)

    expect(class_with_dsl).to have_received(:fill_form).with(:user, FactoryGirl.attributes_for(:user))
  end

  it 'slices the attributes if an attribute whitelist is included' do
    allow(class_with_dsl).to receive(:fill_form)

    fill_with_factory(:user, :name)

    expect(class_with_dsl).to have_received(:fill_form).with(:user, FactoryGirl.attributes_for(:user).slice(:name))
  end

  it 'merges overrides into the attributes' do
    allow(class_with_dsl).to receive(:fill_form)

    fill_with_factory :user, :name, factory_arguments: [name: 'Tao' ]

    expect(class_with_dsl).to have_received(:fill_form).with(:user, { name: 'Tao' })
  end

  delegate :fill_with_factory, to: :class_with_dsl

  def class_with_dsl
    @class ||= Class.new { include Formulaic::Dsl }.new
  end

  def user_class
    @user ||= Class.new do
      attr_accessor :name, :age

      def initialize(options)
        @name = options[:name]
        @age = options[:age]
      end
    end
  end

  def define_user_factory(user_class)
    FactoryGirl.define do
      factory :user, class: user_class do
        name 'Roen Tan'
        age 31
      end
    end
  end
end
