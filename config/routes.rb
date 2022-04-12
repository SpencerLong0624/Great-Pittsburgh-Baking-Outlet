Rails.application.routes.draw do

  #Home Controller Routes
  get 'home', to: 'home#index', as: :home
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  # get 'home/search', to: 'home#search', as: :search

  #Sessions Controller Routes
  resources :sessions, only: [:create]
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  #Users Controller Routes
  resources :users, except: [:destroy, :show]

  #Customers Controller Routes
  resources :customers, except: [:destroy]

  #Addresses Controller Routes
  resources :addresses, except: [:destroy]

  #Categories Controller Routes
  resources :categories, except: [:show, :destroy]

  #Items Controller Routes
  resources :items
  patch 'items/:id/toggle_active', to: 'items#toggle_active', as: :toggle_active
  patch 'items/:id/toggle_feature', to: 'items#toggle_feature', as: :toggle_feature

  #Item_prices Controller Routes
  resources :item_prices, only: [:new, :create]

  #Search Controller Routes
  get 'search/search', to: 'search#search', as: :search

  #Carts Controller Routes
  get 'carts', to: 'cart#show', as: :view_cart
  get 'carts/:id/add_item', to: 'cart#add_item', as: :add_item
  get 'carts/:id/remove_item', to: 'cart#remove_item', as: :remove_item
  get 'carts/empty_cart', to: 'cart#empty_cart', as: :empty_cart
  get 'checkout', to: 'cart#checkout', as: :checkout

  #Orders Controller Routes
  resources :orders, only: [:index, :show, :create]

  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # Only need two routes for the API
      get 'orders', to: 'orders#index'
      get 'customers/:id', to: 'customers#show'
    end
  end
  root 'home#index'
end
