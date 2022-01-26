class PaymentTransaction < ApplicationRecord
	after_create :set_invoice_status
	##validations
    validates :account_holder_fullname , :presence => true,:length => { :within => 2..140 }
  ##associations
  	belongs_to :invoice
  	belongs_to :payment_method
  	has_one_attached :receipt_image
  def set_invoice_status
  	self.invoice.update_columns(invoice_status: "pending")
  end
end
