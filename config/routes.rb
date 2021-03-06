Rails.application.routes.draw do
  resources :users

  namespace :api do
    namespace :v1 do
      resources :users_batch, only: %i[create]
    end
  end

  root 'users#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
