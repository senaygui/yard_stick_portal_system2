class StudentAddress < ApplicationRecord
  ##validations
	  validates :country, :presence => true
		validates :city, :presence => true
		validates :zone, :presence => true
		# validates :house_number, :presence => true
		validates :cell_phone, :presence => true
		validates :woreda, :presence => true
  ##associations
  	belongs_to :student
end
