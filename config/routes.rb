Rails.application.routes.draw do
  get 'azure_oauth2/callback'

  devise_scope :user do
    get '/login', to: 'users/sessions#new', as: 'login'
    post 'logout', to: 'users/sessions#destroy'
  end
  devise_for :users, controllers: { omniauth_callbacks:'callbacks' }

  namespace :admin do
    resources :users, only: [:index, :new, :create]
  end

  resources :orders
  root 'orders#index'
end
