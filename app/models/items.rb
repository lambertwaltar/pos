class Items < ActiveRecord::Base
	#validate form for new item
	validates :name, :presence => true,:uniqueness => true
	validates :price, :presence => true,:numericality => {greater_than: 0}
	validates :quantity, :presence => true

	validates :quantity, :numericality => {greater_than: 0}
end
