class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Usted no tiene permiso para realizar esta accion.'
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(user)
    case user.role
    when :administrator
      users_path
    else
      orders_path
    end
  end
end
