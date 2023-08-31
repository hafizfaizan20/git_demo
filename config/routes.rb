require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: "users#edit_details"
  end
  authenticated :admin do
    root to: "admins#index", as: :authenticated_admin_root
  end
  resources :users, only: [] do
    member do
      get :edit_details
      patch :update_details
      get :verification_page
      post :send_verification_code
      post :verify_code
      get :upload_pdf
      post :save_pdf
      get :show_pdf
    end
  end
  resources :admins, only: [:index] do 
    member do 
      get :show_all_users
    end
  end

  patch "accept/:id", to: "status#accept", as: :accept_user
  delete "reject/:id", to: "status#reject", as: :reject_user

  namespace :api do
    resources :users, only: [] do 
      collection do 
        get :export_users
      end
    end
  end

  mount Sidekiq::Web => "/sidekiq"

  # Defines the root path route ("/")
  # root "articles#index"
end
