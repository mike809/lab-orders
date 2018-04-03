Rails.application.routes.draw do
  root 'orders#index'

  resources :orders, only: [:index, :edit, :update, :delete]
  get 'azure_oauth2/callback'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    post 'logout', to: 'devise/sessions#destroy'
  end

  devise_for :users, :controllers => { :omniauth_callbacks => 'callbacks' }
end
