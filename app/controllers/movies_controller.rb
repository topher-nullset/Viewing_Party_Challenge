# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :require_login, only: %i[discover index show]

  def discover
    @user = current_user
  end

  def index
    @user = current_user
    @facade = MoviesFacade.new(params[:q], params[:keywords])
  end

  def show
    @user = current_user
    @facade = MoviesFacade.new(params[:id], nil).movie_details
  end

  private

  def require_login
    return if current_user

    flash[:error] = 'You must be logged in to access this page'
    redirect_to root_path
  end
end
