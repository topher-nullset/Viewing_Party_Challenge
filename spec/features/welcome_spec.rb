# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome Page' do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    visit root_path
  end

  it 'shows the Application Title' do
    within('#header') do
      expect(page).to have_content('Viewing Party')
    end
  end

  it 'has a button to create a new user' do
    within('#new-user-button') do
      expect(page).to have_button('Create a New User')
      click_on 'Create a New User'
    end

    expect(current_path).to eq(register_path)
  end

  it 'lists all existing users only if logged in' do
    expect(page).to have_content('Hello!')

    User.create(name: 'Original Ethan', email: 'ethan@turing.edu', password: 'test123',
                password_confirmation: 'test123')
    click_button('Log In')

    fill_in 'Email', with: 'ethan@turing.edu'
    fill_in 'Password', with: 'test123'
    click_button('Log In')
    click_link('Home')

    within('#user-list') do
      expect(page).to have_content('Existing Users')
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.email)
      expect(page).to have_content(@user3.email)
      expect(page).to have_content('ethan@turing.edu')
    end
  end

  it 'has a link to the root page' do
    expect(page).to have_link('Home', href: root_path)
  end
end
