class OrdersController < ApplicationController
  def index
    authorize Order
    @orders = policy_scope(Order)
    @order_presenters = @orders.map do |order|
      OrderPresenter.new(order, view_context)
    end
  end

  def new
    authorize Order
    @order = Order.new(new_order_params)
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
    render layout: 'receipt'
  end

  def create
    @order = Order.new(permitted_attributes(Order))
    authorize @order
    if @order.save
      redirect_to order_url(@order)
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    authorize @order
    @order_presenter = OrderPresenter.new(@order, view_context)
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    @order_presenter = OrderPresenter.new(@order, view_context)
    @order.transaction do
      @order.transition!
      flash.now[:info] = 'Orden Recibida'
    end

    render :edit
  end

  private

  def new_order_params
    return unless %i[student].include?(current_user.role.to_sym)
    { "#{current_user.role}_id" => current_user }
  end
end
