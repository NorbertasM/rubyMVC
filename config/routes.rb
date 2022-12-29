Rails.application.routes.draw do
  resources :channel_games
  get 'games/index'
  devise_for :users
  resources :channels

  root 'channels#index'
end
