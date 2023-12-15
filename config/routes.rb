Rails.application.routes.draw do
  get 'welcome/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  authenticated :user do
    root 'rooms#index', as: :authenticated_root
  end
  
  unauthenticated do
    root 'welcome#index', as: :unauthenticated_root
  end

  resources :rooms do
    member do
      post 'take_slot'
      post 'start_game'
      post 'set_visible_characteristic'
      post 'vote_for_player'
    end
    delete 'destroy'
  end

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end
  # Defines the root path route ("/")
  # root "posts#index"
  post '/toggle_visibility/:characteristic_name', to: 'players#toggle_visibility', as: :toggle_visibility
  
  get 'rules', to: 'rules#index'
  get 'contacts', to: 'contacts#index'
end
