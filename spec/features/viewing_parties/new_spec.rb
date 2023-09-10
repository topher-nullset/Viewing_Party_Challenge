# frozen_string_literal: true

require 'rails_helper'

describe 'New Viewing Party Page' do
  before do
    VCR.use_cassette('godfather-movie-details') do
      @user1 = User.create(name: 'Ethan', email: 'ethan@ethan.com', password: '<PASSWORD>', password_confirmation: '<PASSWORD>')
      @user2 = User.create(name: 'Chris', email: 'chris@chris.com', password: '<PASSWORD>', password_confirmation: '<PASSWORD>')
      @user3 = User.create(name: 'Vito', email: 'vito@corleone.com', password: '<PASSWORD>', password_confirmation: '<PASSWORD>')

      @movie = MoviesFacade.new(238, nil).movie_details

      visit user_movie_viewing_party_new_path(@user1.id, @movie.id)
    end
  end

  describe 'new viewing party form' do
    it 'displays the movie title above a form' do
      expect(page).to have_content(@movie.title)
    end

    it "has a 'Duration of Party' field prefilled with the movie's runtime in minutes" do
      expect(page).to have_field('Duration of Party', with: @movie.runtime)
    end

    it 'has date and time selection fields' do
      expect(page).to have_field('When', type: 'date')
      expect(page).to have_field('Start Time', type: 'time')
    end

    it 'has individual checkboxes to invite every other existing user' do
      expect(page).to have_unchecked_field("#{@user2.name} (#{@user2.email})")
      expect(page).to have_unchecked_field("#{@user3.name} (#{@user3.email})")

      expect(page).to_not have_checked_field("#{@user1.name} (#{@user1.email})")
    end

    it 'has a button to create a party' do
      expect(page).to have_button('Create Party').once
    end
  end

  describe 'happy path' do
    it "redirects to the user's dashboard where the new event is shown" do
      check(@user2.name_email)
      click_button('Create Party')

      expect(current_path).to eq(user_path(@user1.id))
      expect(page).to have_content(@movie.title)

      visit user_path(@user2.id)
      expect(page).to have_content(@movie.title)
    end
  end

  describe 'sad path' do
    it "will return an error if the party's duration is less than the film's duration" do
      fill_in('Duration of Party', with: 132)
      fill_in('start_time', with: '10:00')
      VCR.use_cassette('godfather-movie-details') do
        click_button('Create Party')

        expect(current_path).to eq(user_movie_viewing_party_new_path(@user1.id, @movie.id))
        expect(page).to have_content("Error: Viewing party duration must be longer than the movie's runtime")
      end
    end
  end
end
