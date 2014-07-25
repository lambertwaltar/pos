class CartController < ApplicationController

	before_filter :initialize_cart


#delete item
 def destroy
  @item = CartItem.find(params[:id])
  if @item.destroy
    flash[:notice] = "Item removed from Cart"
      redirect_to items_path
  else
    flash[:notice1] = "Failed to delete Item"
  end
end
	
end
