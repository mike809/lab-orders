class OrdersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    authorize Order
    @orders = smart_listing_create :orders,
                                   policy_scope(Order),
                                   partial: 'orders/listing',
                                   array: true,
                                   default_sort: { 'balance' => 'desc' }
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
    @order = Order.new(new_order_params.merge(permitted_attributes(Order)))
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
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    @order.transaction do
      @order.transition!
      flash.now[:info] = 'Orden Recibida'
    end

    respond_to do |format|
      format.html { render :edit }
      format.js
    end
  end

  private

  def new_order_params
    return {} unless %i[student].include?(current_user.role.to_sym)
    { "#{current_user.role}_id" => current_user.id }
  end
end
