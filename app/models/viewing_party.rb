# frozen_string_literal: true

class ViewingParty < ApplicationRecord
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  validates_presence_of :date, :start_time, :duration, :movie_id
end
