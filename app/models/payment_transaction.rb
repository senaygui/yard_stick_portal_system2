class PaymentTransaction < ApplicationRecord
	##validations
    validates :account_holder_fullname , :presence => true,:length => { :within => 2..140 }
  ##associations
  	belongs_to :invoice
  	belongs_to :payment_method
  	has_one_attached :receipt_image
end
