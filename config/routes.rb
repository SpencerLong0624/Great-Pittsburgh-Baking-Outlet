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

  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # Only need two routes for the API
      get 'orders', to: 'orders#index'
      get 'customers/:id', to: 'customers#show'
    end
  end

  

end
