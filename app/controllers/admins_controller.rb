class AdminsController < ApplicationController
  before_action :admin_only

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  private

  def admin_only
    redirect_to after_sign_in_path_for(current_user) unless current_user.admin?
  end
end
