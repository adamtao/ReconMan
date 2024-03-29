Rails.application.routes.draw do

  resources :document_templates
  resources :comments, only: [:new, :create, :edit, :update, :destroy]

  get 'reports' => 'reports#index', as: :reports_index
  post 'reports/run' => 'reports#show', as: :reports
  post 'reports/mark_billed' => 'reports#mark_billed', as: :mark_report_billed

  resources :states do
    resources :counties
  end

  put "county/checkout(/:id)" => 'counties#checkout', as: :checkout_county
  put "county/checkin/:id"  => 'counties#checkin',  as: :checkin_county

  resources :products

  resources :clients do
    resources :branches
    resources :client_products
    resources :users
  end
  resources :jobs do
    resources :tasks, :documentation_tasks, :tracking_tasks, :search_tasks, :special_tasks do
      member do
        get :toggle
        post :toggle
        get :generate_document
        patch :first_notice_sent, :second_notice_sent
        get :research
      end
      resources :title_search_caches
      resources :documents
    end
  end

  post "tasks/:id/toggle_billing" => "tasks#toggle_billing"

  resources :lenders do
    member do
      post :merge
    end
  end

  get 'zipcodes/:id' => 'zipcodes#show'
  get 'file_number/:id' => 'jobs#file_number'

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
