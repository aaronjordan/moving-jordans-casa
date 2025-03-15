Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :events

  get "/items/claims", to: "items#claims"
  post "/items/claim/:id", to: "items#claim", as: "claim"
  post "/items/release/:id", to: "items#release", as: "release"
  resources :items

  resources :categories
  resource :registrations

  get "/home", to: "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
