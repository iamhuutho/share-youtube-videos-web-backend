Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post 'register', to: 'user#create'
  get 'users/:id', to: 'user#show', as: 'user'
  post 'login', to: 'user_session#create'
  delete 'logout', to: 'user_session#destroy'
  resources :videos, only: [:create, :index, :update]
  resources :notifications, only: [:index, :update]
  resources :user_video_interaction, only: [:show]
end