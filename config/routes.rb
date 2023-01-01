Rails.application.routes.draw do
  resources :channel_tags
  resources :preview_statuses
  resources :channel_statuses
  resources :channel_games
  get 'games/index'
  devise_for :users
  resources :channels
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
  end

  root 'channels#index'
end
