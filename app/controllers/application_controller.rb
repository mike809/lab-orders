class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(user)
    case user.role
    when :admin
      users_path
    when :student
      orders_path
    end
  end
end
