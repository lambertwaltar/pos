class CartItem < ActiveRecord::Base
	#dependencies and relationships
	belongs_to :cart
  	belongs_to :items

  	
	validates :quantity, :numericality => {:only_integer => true}

end
