class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @order_presenters = Order.all.map { |order| OrderPresenter.new(order, view_context) }
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


  def edit
    @order = OrderPresenter.new(Order.find(params[:id]), view_context)
  end

  def update
    @order = Order.find(params[:id])
    @order.transaction do
      @order.transition!
      flash.now[:info] = 'Orden Recibida'
    end

    render :edit
  end

  private

  def order_params
    params.fetch(:order, {}).permit(:student_id, :teacher_id, :patient_id)
  end
end
