Rails.application.routes.draw do
  root 'devise/sessions#new'
  devise_for :users
end
