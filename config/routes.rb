Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  resources :products

  # new routes for create products
  # post '/products', to: 'products#create_v2', as: 'createv2'
end
