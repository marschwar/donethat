Rails.application.routes.draw do

  root 'trips#index'
  resources :trips do
    resources :notes
    collection do
      get :my
    end
  end

  resources :sessions
  get '/logout', to: 'sessions#clear'

  # Omniauth success callback
  get  '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'

  # API
  namespace :api do
    resources :trips, param: :uid, only: [:index, :show, :create, :update, :destroy] do
      resources :notes, param: :uid, only: [:create, :update, :destroy]
    end
  end

end
