class ItemsController < ApplicationController

  before_filter :login_required
  before_filter :confirm_admin, :except=>[:index,:autocomplete]
  protect_from_forgery


	def index
    @others = Items.all #pick all items from items database
    @index = Items.new
    @item=CartItem.all #pick all items from cartitems database

    $total = CartItem.sum('subtotal') #sum from the subtotals field

    if params[:text].present? #check if item was selected
      if params[:quantity].present? #check if quantity was intered
        @items = Items.where(:name=>params[:text]) 
        $quantity = params[:quantity]
        if $quantity.to_i > 0  #check if quantity is a positive integer
        
        if @items
          items = Items.find_by_name(params[:text])   
          if items.quantity.to_i>$quantity.to_i #check if item is still in stock

            #check if item has already been added to cart
            if CartItem.exists?(:cart_id => initialize_cart.id, :name => items.name)
              item = CartItem.find(:first, :conditions => [ "cart_id = #{initialize_cart.id} AND items_id = #{items.id}" ])
              #if yes update the quantity
              CartItem.update(item.id, :quantity => item.quantity.to_i+$quantity.to_i, :subtotal =>(item.quantity.to_i+$quantity.to_i)*item.price)
              flash[:notice] = "updated quantity"
              Items.update(items.id, :quantity => items.quantity.to_i-$quantity.to_i)
            #if not add it to cart as new item
            else
              @cart_item = CartItem.create!(:cart => initialize_cart, :items_id => items.id, :name=>items.name, :quantity => $quantity, :price => items.price, :subtotal=>$quantity.to_i*items.price.to_i)
              #update the items table
              Items.update(items.id, :quantity => items.quantity.to_i-$quantity.to_i)
              #create / open log file and write to it
              logger = Logger.new(File.join(Rails.root, '/public/transaction.log'))
              loggerinfo = File.open(File.join(Rails.root, '/public/transaction.log'), 'r')
              if loggerinfo == nil              
                logger.info("Item   |   Quantity  |  Unit Price   |  Total    |   Cashier")
                logger.info("------------------------------------------------------------")

                logger.info(items.name.to_s+"    |   "+$quantity.to_s+"    |   "+items.price.to_s+"    |   "+$total.to_s)
                 logger.close
              else
                logger.info(items.name.to_s+"    |   "+$quantity.to_s+"    |   "+items.price.to_s+"    |   "+($quantity.to_i*items.price.to_i).to_s)
                puts " hhaa"
                logger.close
              end
                #flash message for the view
                flash[:notice] = "Added #{items.name} to cart."
            end

          else
            #flash message for the view
            flash[:notice1] = "Item #{items.name} out of stock"
          end
        #guide cashier to cashier page
        redirect_to items_path
      end
    else
      #flash message for the view
      flash[:notice1] = "Quantity is not valid"
    end
    end


  return @items
    else
      myarray = Items.all
      @items = Kaminari.paginate_array(myarray).page(params[:page])
    end
  end

  #clear customer cart method
  def new_sale
    CartItem.destroy_all
    Cart.destroy_all
    session[:cart_id] = nil
    redirect_to items_path
  end


  def autocomplete
    render json: Items.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  #display items
  def show
    @items=Items.all
  end
  #create new item
  def new
    @items = Items.new
    $name = params[:name]
  end

  #display items
  def view_stock
    @items=Items.all
  end

  #create new item and add it to database
  def create
    @items = Items.new(params[:items].permit(:name, :price, :quantity))
    if @items.save #save item
      flash[:notice1] = "New Item Added"
      redirect_to new_item_path
    else
      @items.errors.full_messages.each do |message_error|   
        flash[:notice2] = message_error
        redirect_to new_item_path
        return false 
        end
  
    end
  end

#delete item
 def destroy
  @item = Items.find(params[:id])
  if @item.destroy
    flash[:notice] = "Item deleted"
      redirect_to items_view_stock_path
  else
    flash[:notice1] = "Failed to delete Item"
  end
end
end
