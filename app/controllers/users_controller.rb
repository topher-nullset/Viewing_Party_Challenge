# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back #{user.name}"
      redirect_to user_path(user.id)
    else
      flash[:error] = 'Invalid credentials'
      redirect_to login_path
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
