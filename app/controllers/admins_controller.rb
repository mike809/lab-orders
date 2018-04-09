class AdminsController < ApplicationController
  before_action :admin_only

  private

  def admin_only
    redirect_to after_sign_in_path_for(current_user) unless current_user.admin?
  end
end
