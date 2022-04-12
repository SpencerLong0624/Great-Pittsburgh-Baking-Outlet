class ItemPricesController < ApplicationController
  def new
    @item = Item.all.paginate(page: params[:page]).per_page(15)
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    if @item_price.save
      flash[:notice] = "Successfully updated the price."
      redirect_to item_path(ItemPrice.last.item)
    else
      render action: 'new'
    end
  end

  private
  def item_price_params
    params.require(:item_price).permit(:item_id, :price)
  end
end
