class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy, :toggle_active, :toggle_feature]
  authorize_resource

  def index
    @categories = Category.active.alphabetical
    if params.has_key?(:category)
      @category = Category.find(params[:category])
      @featured_items = Item.featured.active.for_category(@category).alphabetical.paginate(page: params[:page]).per_page(15)
      @other_items = Item.active.where(is_featured: false).for_category(@category).alphabetical.paginate(page: params[:page]).per_page(15)
    else
      @featured_items = Item.featured.active.alphabetical.paginate(page: params[:page]).per_page(15)
      @other_items = Item.active.where(is_featured: false).alphabetical.paginate(page: params[:page]).per_page(15)
    end
  end

  def show
    @prices = @item.item_prices.paginate(page: params[:page]).per_page(15)
    @similar_items = @item.category.items.paginate(page: params[:page]).per_page(15)
  end

  def toggle_active
    if @item.active
      @item.update_attribute(:active, false)
      flash[:notice] = "#{@item.name} was made inactive"

    else
      @item.update_attribute(:active, true)
      flash[:notice] = "#{@item.name} was made active"
    end
    redirect_to item_path(@item)
  end

  def toggle_feature
    if @item.is_featured
      @item.update_attribute(:is_featured, false)
      flash[:notice] = "#{@item.name} is no longer featured"

    else
      @item.update_attribute(:is_featured, true)
      flash[:notice] = "#{@item.name} is now featured"
    end
    redirect_to item_path(@item)
  end

  def new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "#{@item.name} was added to the system."
      redirect_to item_path(Item.last)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:notice] = "Successfully updated #{@item.name}."
      redirect_to item_path(@item)
    else
      render action: 'edit'
    end
  end

  def destroy
    if @item.order_items.empty?
      @item.destroy
      redirect_to items_path
    else
      redirect_to item_path(@item)
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:category_id, :name, :description, :color, :weight, :inventory_level, :reorder_level, :is_featured, :active)
  end
end
