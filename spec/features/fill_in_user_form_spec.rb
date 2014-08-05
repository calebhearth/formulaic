require 'spec_helper'
require 'pathname'

describe 'Fill in user form' do

  before(:all) { load_translations }

  it 'finds and fills text fields' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, name: 'George')

    form.fill

    expect(input(:user, :name).value).to eq 'George'
  end

  it 'finds and fills a password field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, password: 'supersecr3t')

    form.fill

    expect(input(:user, :password).value).to eq 'supersecr3t'
  end

  it 'finds and fills a email field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, email: 'caleb@example.com')

    form.fill

    expect(input(:user, :email).value).to eq 'caleb@example.com'
  end

  it 'finds and fills a tel field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, phone: '123-555-1234')

    form.fill

    expect(input(:user, :phone).value).to eq '123-555-1234'
  end

  it 'finds and fills a url field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, url: 'https://github.com')

    form.fill

    expect(input(:user, :url).value).to eq 'https://github.com'
  end

  it 'finds and fills a textarea' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, bio: 'blah blah blah')

    form.fill

    expect(input(:user, :bio).value).to eq 'blah blah blah'
  end

  it 'finds and fills a date field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, date_of_birth: Date.new(1980, 1, 2))

    form.fill

    expect(page.find('#user_date_of_birth_1i').value).to eq('1980')
    expect(page.find('#user_date_of_birth_2i').value).to eq('1')
    expect(page.find('#user_date_of_birth_3i').value).to eq('2')
  end

  it 'finds and checks a boolean field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, terms_of_service: true)

    form.fill

    expect(input(:user, :terms_of_service)).to be_checked
  end

  it 'finds and fills in a number field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, age: 10)

    form.fill

    expect(input(:user, :age).value).to eq '10'
  end

  it 'selects a string if there is no input' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, awesome: 'Yes')

    form.fill

    expect(page).to have_select('user_awesome', selected: 'Yes')
  end

  it 'attaches a file to a file field' do
    visit 'user_form'
    file = File.open('spec/fixtures/file.txt')
    form = Formulaic::Form.new(:user, :new, avatar: file)

    form.fill

    expect(input(:user, :avatar).value).to eq file.path
  end
end
