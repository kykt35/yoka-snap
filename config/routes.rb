Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "posts#index"

  resources :posts, only: [:index, :show, :new, :create] do
    post "reactions/:reaction_type", to: "reactions#create", as: :reactions
    delete "reactions/:reaction_type", to: "reactions#destroy", as: :reaction
  end

  resource :my_page, only: :show
  resources :want_to_go_posts, only: :index

  namespace :admin do
    resources :posts, only: [:index, :show] do
      patch :publish, on: :member
      patch :hide, on: :member
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
