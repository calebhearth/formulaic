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

  it 'finds and fills a spanish locale date field' do
    I18n.locale = :es
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, date_of_birth: Date.new(1980, 1, 2))
    form.fill

    expect(page.find('#user_date_of_birth_1i').value).to eq('1980')
    expect(page.find('#user_date_of_birth_2i').value).to eq('1')
    expect(page.find('#user_date_of_birth_3i').value).to eq('2')
    I18n.locale = :en
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

  it 'raises a useful error if selecting multiple from a normal select' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, awesome: ['Yes', 'No'])

    expect { form.fill }
      .to raise_error(
        Formulaic::InputNotFound,
        'Unable to find checkboxes or select[multiple] "Are you awesome?" containing all options ["Yes", "No"].'
      )
  end

  it 'raises a useful error if not all select options are present' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, likes: ['Ruby', 'Perl'])

    expect { form.fill }
      .to raise_error(
        Formulaic::InputNotFound,
        'Unable to find checkboxes or select[multiple] "Your Likes" containing all options ["Ruby", "Perl"].'
      )
  end

  it 'selects an array of strings' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, likes: ['Ruby', 'Rails'])

    form.fill

    expect(input(:user, :likes).value).to eq ['ruby', 'rails']
  end

  it 'raises a useful error if not all checkboxes are present' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, dislikes: ['Java', 'Go'])

    expect { form.fill }
      .to raise_error(
        Formulaic::InputNotFound,
        'Unable to find checkboxes or select[multiple] "Your Dislikes" containing all options ["Java", "Go"].'
      )
  end

  it 'selects an array of checkboxes' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, dislikes: ['Java', 'PHP'])

    form.fill

    expect(page).to have_checked_field "Java"
    expect(page).to have_checked_field "PHP"
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

  it 'finds and fills a date field regardless of select box order' do
    visit 'event_form'

    form = Formulaic::Form.new :event, :new,
      "Starts on" => Date.new(2014, 3, 4),
      "Ends on" =>  Date.new(2015, 12, 31)

    form.fill

    expect(page.find('#event_starts_on_1i').value).to eq('2014')
    expect(page.find('#event_starts_on_2i').value).to eq('3')
    expect(page.find('#event_starts_on_3i').value).to eq('4')

    expect(page.find('#event_ends_on_1i').value).to eq('2015')
    expect(page.find('#event_ends_on_2i').value).to eq('12')
    expect(page.find('#event_ends_on_3i').value).to eq('31')
  end

end
