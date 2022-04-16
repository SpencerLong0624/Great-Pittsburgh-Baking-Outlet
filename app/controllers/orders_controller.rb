class OrdersController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  before_action :set_order, only: [:show]

  def index
    if current_user.role?(:admin)
      @pending_orders = Order.paid.paginate(page: params[:page]).per_page(15)
      @past_orders = Order.all - Order.paid
    else
      @all_orders = Order.paginate(page: params[:page]).per_page(15)
    end
  end

  def show
    @previous_orders = @order.customer.orders.paid.paginate(page: params[:page]).per_page(15)
    @order_items = @order.order_items.paginate(page: params[:page]).per_page(15)
  end

  def create
    @order = Order.new(order_params)
    @order.products_total = calculate_cart_items_cost
    @order.date = Date.current
    @order.shipping = calculate_cart_shipping
    if @order.save
      @order.pay
      save_each_item_in_cart(@order)
      clear_cart
      flash[:notice] = "Thank you for ordering from GPBO."
      redirect_to order_path(Order.last)
    else
      redirect_to checkout_path()
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :address_id, :credit_card_number, :expiration_year, :expiration_month, :products_total, :date, :shipping)
  end
end
