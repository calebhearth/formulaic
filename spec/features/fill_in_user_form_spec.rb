require 'spec_helper'

%w[user_form user_form_only_ids].each do |fixture_url|
  describe "Fill in #{fixture_url.humanize}" do

    before(:all) { load_translations }

    before do
      visit fixture_url
    end

    it 'finds and fills text fields' do
      form = Formulaic::Form.new(:user, name: 'George')

      form.fill

      expect(input(:user, :name).value).to eq 'George'
    end

    it 'finds and fills a password field' do
      form = Formulaic::Form.new(:user, password: 'supersecr3t')

      form.fill

      expect(input(:user, :password).value).to eq 'supersecr3t'
    end

    it 'finds and fills a email field' do
      form = Formulaic::Form.new(:user, email: 'caleb@example.com')

      form.fill

      expect(input(:user, :email).value).to eq 'caleb@example.com'
    end

    it 'finds and fills a tel field' do
      form = Formulaic::Form.new(:user, phone: '123-555-1234')

      form.fill

      expect(input(:user, :phone).value).to eq '123-555-1234'
    end

    it 'finds and fills a url field' do
      form = Formulaic::Form.new(:user, url: 'https://github.com')

      form.fill

      expect(input(:user, :url).value).to eq 'https://github.com'
    end

    it 'finds and fills a textarea' do
      form = Formulaic::Form.new(:user, bio: 'blah blah blah')

      form.fill

      expect(input(:user, :bio).value).to eq 'blah blah blah'
    end

    it 'finds and fills a date field' do
      form = Formulaic::Form.new(:user, date_of_birth: Date.new(1980, 1, 2))

      form.fill

      expect(page.find('#user_date_of_birth_1i').value).to eq('1980')
      expect(page.find('#user_date_of_birth_2i').value).to eq('1')
      expect(page.find('#user_date_of_birth_3i').value).to eq('2')
    end

    it 'finds and checks a boolean field' do
      form = Formulaic::Form.new(:user, terms_of_service: true)

      form.fill

      expect(input(:user, :terms_of_service)).to be_checked
    end

    it 'selects a string if there is no input' do
      form = Formulaic::Form.new(:user, awesome: 'Yes')

      form.fill

      expect(page).to have_select('user_awesome', selected: 'Yes')
    end
  end
end
