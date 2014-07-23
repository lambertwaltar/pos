class Cart < ActiveRecord::Base
	#dependencies and relationships
	has_many :cart_items
  	has_many :items, :through => :cart_items

end
