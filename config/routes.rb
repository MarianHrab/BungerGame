Rails.application.routes.draw do
  get 'welcome/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
  unauthenticated do
    root 'welcome#index', as: :unauthenticated_root
  end
  resources :rooms do
    member do
      post 'take_slot'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
