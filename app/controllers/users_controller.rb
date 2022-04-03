class UsersController < ApplicationController
  before_action :set_user, only: [:update]
  def index
    @employees = User.all.paginate(page: params[:page]).per_page(15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "admin" if current_user.role?(:admin)
    if @user.save
      flash[:notice] = "Successfully added #{@user.username} as a user."
      redirect_to users_url
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.username}."
      redirect_to users_url
    else
      render action: 'edit'
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :role, :active)
  end
end
