class SearchController < ApplicationController
  def search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    if current_user.role?(:customer)
      @items = Item.search(@query)
      @total_hits = @items.size
    else
      @customers = Customer.search(@query)
      @items = Item.search(@query)
      @total_hits = @customers.size + @items.size
    end
  end
end
