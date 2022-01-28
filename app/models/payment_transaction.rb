class PaymentTransaction < ApplicationRecord
	after_create :set_invoice_status
	##validations
    validates :account_holder_fullname , :presence => true,:length => { :within => 2..140 }
    validates :phone_number , :presence => true
    validates :receipt_image, attached: true, content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg']

  ##associations
  	belongs_to :invoice
  	belongs_to :payment_method
  	has_one_attached :receipt_image
  def set_invoice_status
  	self.invoice.update_columns(invoice_status: "pending")
  end
end
