# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, only: [:show]

  def show
    @user = current_user
    @viewing_parties = @user.viewing_parties
  end

  def new; end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = 'User successfully created'
      redirect_to user_path(user.id)
    else
      flash[:error] = "Error: #{error_message(user.errors)}"
      redirect_to register_path
    end
  end

  def login_form; end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back #{user.name}"
      redirect_to user_path(user.id)
    else
      flash[:error] = 'Invalid credentials'
      redirect_to login_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def require_login
    return if current_user

    flash[:error] = 'You must be logged in to access this page'
    redirect_to root_path
  end
end
