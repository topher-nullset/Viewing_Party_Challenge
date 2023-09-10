require 'rails_helper'

RSpec.describe 'User login', type: :feature do
  describe 'login page' do
    before do
      @user = User.create(name: 'Original Ethan', email: 'ethan@turing.edu', password: 'test123', password_confirmation: 'test123')
    end

    it 'can log in an existing user' do
      visit root_path
      expect(page).to have_button('Log In')

      click_button 'Log In'
      expect(current_path).to eq(login_path)

      within('#login-form') do
        expect(page).to have_field('Email')
        expect(page).to have_field('Password')
      end

      fill_in 'Email', with: 'ethan@turing.edu'
      fill_in 'Password', with: 'test123'

      click_button 'Log In'
      expect(current_path).to eq(user_path(@user.id))
      expect(page).to have_content("Welcome back Original Ethan")
      expect(page).to have_content("Original Ethan's Dashboard")
    end

    it 'fails when wrong credentials are provided' do
      visit login_path

      # Wrong email
      within('#login-form') do
        fill_in 'Email', with: 'wrong@email.com'
        fill_in 'Password', with: 'test123'
        click_button 'Log In'
      end

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Invalid credentials')

      # Wrong password
      within('#login-form') do
        fill_in 'Email', with: 'ethan@turing.edu'
        fill_in 'Password', with: 'imsotired'
        click_button 'Log In'
      end

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Invalid credentials')
    end
  end
end