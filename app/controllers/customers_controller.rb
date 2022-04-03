class CustomersController < ApplicationController
  #Callbacks
  before_action :check_login, only: [:index, :show]
  before_action :set_customer, only: [:show]

  def new
    @customer = Customer.new
  end

  def edit
  end

  def show
    @previous_orders = @customer.orders #maybe not return only previous orders
    @addresses = @customer.addresses
  end

  def create
    @customer = Customer.new(customer_params)
    @user = User.new(user_params)
    @user.role = "owner"
    if !@user.save
      @owner.valid?
      render action: 'new'
    else
      @owner.user_id = @user.id
      if @owner.save
        flash[:notice] = "Successfully created #{@owner.proper_name}."
        redirect_to owner_path(@owner) 
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
