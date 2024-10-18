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
  post 'logout', to: 'user_session#logout'
  resources :videos, only: [:create, :index, :update]
  resources :notification, only: [:create, :index, :update]
  get 'user_video_interaction/:video_id/:username', to: 'user_video_interaction#get_interaction'
  put 'user_video_interaction/:id', to: 'user_video_interaction#update'
  resources :notification_history, only: [:create, :update]
end