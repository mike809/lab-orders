class Users::SessionsController < Devise::SessionsController
  layout 'application'
  before_action :authenticate_user!, only: :destroy

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end
end
