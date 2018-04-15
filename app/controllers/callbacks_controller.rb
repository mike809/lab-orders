class CallbacksController < ApplicationController
  skip_before_action :authenticate_user!
  def azure_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user
  end
end
