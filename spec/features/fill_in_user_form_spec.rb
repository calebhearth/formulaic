require 'spec_helper'

%w[user_form user_form_with_ids].each do |url|
  describe "Fill in #{url.humanize}" do

    before(:all) { load_translations }

    before do
      visit url

      form.fill
    end

    context 'finds and fills text fields' do
      subject(:form) { Formulaic::Form.new(:user, name: 'George') }

      it { expects(input(:user, :name).value).to eq 'George' }
      # it { expects(form.matches?(name: 'George')).to be_true }
    end

    context 'finds and fills a password field' do
      subject(:form) { Formulaic::Form.new(:user, password: 'supersecr3t')  }

      it { expects(input(:user, :password).value).to eq 'supersecr3t' }
      # it { expects(form.matches?(password: 'supersecr3t')).to be_true }
    end

    context 'finds and fills a email field' do
      subject(:form) { Formulaic::Form.new(:user, email: 'caleb@example.com') }

      it { expects(input(:user, :email).value).to eq 'caleb@example.com' }
      # it { expects(form.matches?(email: 'caleb@example.com')).to be_true }
    end

    context 'finds and fills a tel field' do
      subject(:form) { Formulaic::Form.new(:user, phone: '123-555-1234') }

      it { expects(input(:user, :phone).value).to eq '123-555-1234' }
      # it { expects(form.matches?(phone: '123-555-1234')).to be_true }
    end

    context 'finds and fills a url field' do
      subject(:form) { Formulaic::Form.new(:user, url: 'https://github.com') }

      it { expects(input(:user, :url).value).to eq 'https://github.com' }
      # it { expects(form.matches?(url: 'https://github.com')).to be_true }
    end

    context 'finds and fills a textarea' do
      subject(:form) { Formulaic::Form.new(:user, bio: 'blah blah blah') }

      it { expects(input(:user, :bio).value).to eq 'blah blah blah' }
      # it { expects(form.matches?(bio: 'blah blah blah')).to be_true }
    end

    context 'finds and fills a date field' do
      subject(:form) { Formulaic::Form.new(:user, date_of_birth: Date.new(1980, 1, 2)) }

      it { expects(page.find('#user_date_of_birth_1i').value).to eq('1980') }
      it { expects(page.find('#user_date_of_birth_2i').value).to eq('1') }
      it { expects(page.find('#user_date_of_birth_3i').value).to eq('2') }

      # it { expects(form.matches?(date_of_birth: Date.new(1980, 1, 2))).to be_true }
    end

    context 'finds and checks a boolean field' do
      subject(:form) { Formulaic::Form.new(:user, terms_of_service: true) }

      it { expects(input(:user, :terms_of_service)).to be_checked }
      # it { expects(form.matches?(terms_of_service: true)).to be_true }
    end

    context 'selects a string if there is no input' do
      subject(:form) { Formulaic::Form.new(:user, awesome: 'Yes') }

      it { expects(page).to have_select('user_awesome', selected: 'Yes') }
      # it { expects(form.matches?(awesome: 'Yes')).to be_true }
    end
  end
end
