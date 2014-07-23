class CartItem < ActiveRecord::Base
	#dependencies and relationships
	belongs_to :cart
  	belongs_to :items

end
