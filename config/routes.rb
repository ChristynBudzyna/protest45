Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :events
  get "/filter_by_tag", to: 'events#filter_by_tag'

  get '/'=> 'events#index'
   get '/tips', to: 'pages#tips'
   get '/admin', to: 'pages#admin'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'


end
