class Users::SessionsController < Devise::SessionsController
  layout 'application'
  before_action :authenticate_user!, only: :destroy
end
