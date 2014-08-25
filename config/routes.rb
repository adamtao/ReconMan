Rails.application.routes.draw do

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
      resources :title_search_caches
    end
  end

  root to: 'dashboard#index'
  devise_for :users, :skip => [:registrations]                                          
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
      patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'            
    end
  resources :users
end
