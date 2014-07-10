Rails.application.routes.draw do

  resources :states do 
    resources :counties
  end

  resources :products

  resources :clients do 
    resources :branches
  end
  resources :jobs do
    resources :job_products
  end

  root to: 'dashboard#index'
  devise_for :users
  resources :users
end
