Rails.application.routes.draw do
  get 'azure_oauth2/callback'

  devise_scope :user do
    get "signup", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    post "session", to: "devise/sessions#create"
    get "logout", to: "devise/sessions#destroy"
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
end
