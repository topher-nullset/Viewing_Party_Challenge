# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should have_secure_password }
  end

  describe 'associations' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'instance methods' do
    it '#name_email' do
      user = User.create(name: 'Ethan', email: 'ethan@ethan.com')

      expect(user.name_email).to eq('Ethan (ethan@ethan.com)')
    end
  end

  it 'users' do
    user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
    expect(user).to_not have_attribute(:password)
    expect(user.password_digest).to_not eq('password123')
  end
end
