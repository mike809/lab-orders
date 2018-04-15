class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

  def after_sign_in_path_for(user)
    case user.role
    when :administrator
      users_path
    else
      orders_path
    end
  end
end
