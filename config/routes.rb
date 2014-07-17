Rails.application.routes.draw do

  resources :states do 
    resources :counties
  end

  resources :products

  resources :clients do 
    resources :branches
    resources :client_products
  end
  resources :jobs do
    resources :job_products do
      resources :title_search_caches
    end
  end

  root to: 'dashboard#index'
  devise_for :users
  resources :users
end
