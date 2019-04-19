Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show create edit destroy]
      resources :sessions, only: %i[create destroy]

      post '/random', to: 'recommendations#random_suggestion'
      get '/profile', to: 'users#show'
    end
  end
end
