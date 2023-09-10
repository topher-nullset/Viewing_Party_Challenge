# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'welcome#index'

  get '/register', to: 'users#new'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout'
  resources :users, only: %i[create show] do
    get '/discover', to: 'movies#discover'
    resources :movies, only: %i[index show] do
      get '/viewing_party/new', to: 'viewing_parties#new'
      post '/viewing_party', to: 'viewing_parties#create'
    end
  end
end
