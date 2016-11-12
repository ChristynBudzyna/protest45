Rails.application.routes.draw do

  devise_for :users
  resources :events
  resources :users, only: [:new, :create]

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'


end
