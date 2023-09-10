# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    record.errors.add attribute, options[:message] || "'#{value}' is not a valid email"
  end
end

class User < ApplicationRecord
  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  has_secure_password

  def name_email
    "#{name} (#{email})"
  end

  def hosting_status_for(viewing_party)
    viewing_party_users.find_by(viewing_party:)&.hosting? || false
  end
end
