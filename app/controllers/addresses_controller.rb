class AddressesController < ApplicationController
  before_action :set_address, only: [:update, :show]
  authorize_resource

  def index
    @active_addresses = Address.active.paginate(page: params[:page]).per_page(15)
    @inactive_addresses = Address.inactive.paginate(page: params[:page]).per_page(15)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:notice] = "The address was added to #{@address.customer.proper_name}."
      redirect_to customer_path(@address.customer)
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @address.update_attributes(address_params)
      flash[:notice] = "Successfully updated address by #{@address.customer.proper_name}."
      redirect_to addresses_path
    else
      render action: 'edit'
    end
  end

  private
  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:customer_id, :is_billing, :recipient, :street_1, :city, :state, :zip, :active)
  end
end
