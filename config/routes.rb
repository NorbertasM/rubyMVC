Rails.application.routes.draw do
  get 'games/index'
  devise_for :users
  resources :channels

  root 'channels#index'
end
