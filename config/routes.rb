Rails.application.routes.draw do
  resources :segments
  resources :papuas
  devise_for :users
  #get 'home/index'
  root 'home#index'
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
