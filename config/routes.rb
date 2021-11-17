Rails.application.routes.draw do
  resources :segments
  resources :papuas
  devise_for :users
  get 'whatsnew/index'
  get 'phonemes/index'
  root 'home#index'
  #resources :products
  resources :searches
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
