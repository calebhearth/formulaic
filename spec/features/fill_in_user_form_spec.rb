require 'spec_helper'
require 'pathname'

describe 'Fill in user form' do
  it 'finds and fills text fields' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, name: 'George')

    form.fill

    expect(input(:user, :name).value).to eq 'George'
  end

  it 'finds and fills text fields with symbol values' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, name: :George)
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

  it 'finds and fills a datetime field' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, date_of_birth: DateTime.new(1980, 1, 2, 10, 30))

    form.fill

    expect(page.find('#user_date_of_birth_1i').value).to eq('1980')
    expect(page.find('#user_date_of_birth_2i').value).to eq('1')
    expect(page.find('#user_date_of_birth_3i').value).to eq('2')
    expect(page.find('#user_date_of_birth_4i').value).to eq('10')
    expect(page.find('#user_date_of_birth_5i').value).to eq('30')
  end

  it 'finds and fills a spanish locale date field' do
    begin
      I18n.locale = :es
      visit 'user_form_es'
      form = Formulaic::Form.new(:user, :new, date_of_birth: Date.new(1980, 1, 2))

      form.fill

      expect(page.find('#user_date_of_birth_1i').value).to eq('1980')
      expect(page.find('#user_date_of_birth_2i').value).to eq('1')
      expect(page.find('#user_date_of_birth_3i').value).to eq('2')
    ensure
      I18n.locale = :en
    end
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

  it 'finds an fills in a number field which is a float' do
    visit 'user_form'
    form = Formulaic::Form.new(:user, :new, score: 23.53)

    form.fill

    expect(input(:user, :score).value).to eq '23.53'
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

  it 'knows to use _ids for association fields' do
    visit 'user_form'

    form = Formulaic::Form.new(:user, :new, friends: ['Caleb'])

    form.fill

    expect(page.find('#user_friend_ids_1')).to be_checked
  end

  it 'raises an useful error when option not found for select' do
    visit 'user_form'

    form = Formulaic::Form.new(:user, :new, role: :unknown)

    expect { form.fill }
      .to raise_error(
        Formulaic::OptionForSelectInputNotFound,
        %[Unable to find option with text matching "unknown".])
  end

  it 'translate option for select when translation is available' do
    visit 'user_form'

    form = Formulaic::Form.new(:user, :new, role: :admin)
    form.fill

    expect(page).to have_select('user_role', selected: 'Administrator')
  end
end
