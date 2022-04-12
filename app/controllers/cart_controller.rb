class CartController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  before_action :set_item, only: [:add_item, :remove_item]

  def show
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = @subtotal + @shipping_cost
  end

  def add_item
    add_item_to_cart(@item.id)
    flash[:notice] = "#{@item.name} was added to cart."
    redirect_to view_cart_path
  end

  def remove_item
    remove_item_from_cart(@item.id)
    flash[:notice] = "#{@item.name} was removed from cart."
    redirect_to view_cart_path
  end

  def empty_cart
    clear_cart
    flash[:notice] = "Cart is emptied."
    redirect_to view_cart_path
  end

  def checkout
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = @subtotal + @shipping_cost
    @addresses = current_user.customer.addresses
    @order = Order.new
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
end
