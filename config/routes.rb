Rails.application.routes.draw do
  devise_for :users
  resources :channels

  root 'channels#index'
end
