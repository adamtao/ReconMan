Rails.application.routes.draw do

  resources :comments, only: [:new, :create, :edit, :update, :destroy]

  get 'reports/index' => 'reports#index', as: :reports_index

  resources :states do
    resources :counties
  end

  resources :products

  resources :clients do
    resources :branches
    resources :client_products
    resources :users
  end
  resources :jobs do
    resources :job_products do
      member do
        get :toggle
        post :toggle
      end
      resources :search_logs, only: :create
      resources :title_search_caches
      resources :documents
    end
  end

  resources :lenders

  get 'zipcodes/:id' => 'zipcodes#show'

  root to: 'dashboard#index'
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
    end
  scope :admin do # wrap in a scope to avoid devise conflicts (allows admin to maintain users)
    resources :users
  end
end
