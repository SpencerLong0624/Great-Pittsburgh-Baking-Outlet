class CustomersController < ApplicationController
  include AppHelpers::Cart
  #Callbacks
  before_action :check_login, only: [:index, :show, :update, :edit]
  before_action :set_customer, only: [:show, :update, :edit]
  authorize_resource

  def new
    @customer = Customer.new
  end

  def edit
  end

  def show
    @previous_orders = @customer.orders.paid
    @addresses = @customer.addresses
  end

  def create
    @customer = Customer.new(customer_params)
    @user = User.new(user_params)
    @user.role = "customer"
    if !@user.save
      @customer.valid?
      render action: 'new'
    else
      @customer.user_id = @user.id
      if @customer.save
        flash[:notice] = "#{@customer.proper_name} was added to the system."
        session[:user_id] = @customer.user.id
        create_cart
        redirect_to customer_path(@customer) 
      else
        render action: 'new'
      end      
    end
  end

  def index
    @active_customers = Customer.active.alphabetical.paginate(page: params[:page]).per_page(15)
    @inactive_customers = Customer.inactive.alphabetical.paginate(page: params[:page]).per_page(15)
  end

  def update
    respond_to do |format|
      if @customer.update_attributes(customer_params)
        format.html { redirect_to(@customer, :notice => "Successfully updated #{@customer.proper_name}.") }
        format.json { respond_with_bip(@customer) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@customer) }
      end
    end
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, :username, :password, :password_confirmation, :role, :greeting)
    end

    def user_params      
      params.require(:customer).permit(:username, :password, :password_confirmation, :role, :active)
    end
end
