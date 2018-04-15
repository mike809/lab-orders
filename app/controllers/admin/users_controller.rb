class Admin::UsersController < AdminsController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :find_user, except: [:index, :new, :create]

  def index
    @students = smart_listing_create :users_with_orders,
                                     User.with_orders,
                                     partial: 'admin/users/listing',
                                     default_sort: { pending_balance: :desc }

    @other_users = smart_listing_create :users_without_orders,
                                        User.without_orders,
                                        partial: 'admin/users/listing'
  end

  def new
    @user = User.new
  end

  def update
    @user.update(user_params)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit(:full_name, :role)
  end
end
