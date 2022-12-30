Rails.application.routes.draw do
  resources :channel_tags
  resources :preview_statuses
  resources :channel_statuses
  resources :channel_games
  get 'games/index'
  devise_for :users
  resources :channels

  root 'channels#index'
end
