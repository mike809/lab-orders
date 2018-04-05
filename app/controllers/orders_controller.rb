class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_url
    else
      render :new
    end
  end

  private

  def order_params
    params.fetch(:order, {}).permit(:student_id, :teacher_id, :patient_id)
  end
end
