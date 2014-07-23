class Items < ActiveRecord::Base
	#validate form for new item
	validates :name, :presence => true
	validates :price, :presence => true,:numericality => {:only_integer => true}
	validates :quantity, :presence => true

	validates :quantity, :numericality => {:only_integer => true}
end
