class Items < ActiveRecord::Base
	#validate form for new item
	validates :name, :presence => true
	validates :price, :presence => true
	validates :quantity, :presence => true
end
