class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
    render layout: 'receipt'
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to order_url(@order)
    else
      render :new
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      format.js {
        @order.transition!
        redirect_to order_path(@order)
      }
    end
  end

  private

  def order_params
    params.fetch(:order, {}).permit(:student_id, :teacher_id, :patient_id)
  end
end
