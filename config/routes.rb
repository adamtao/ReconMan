Rails.application.routes.draw do

  resources :jobs
  resources :clients
  resources :counties

  root to: 'jobs#index'
  devise_for :users
  resources :users
end
