class InvoiceItem < ApplicationRecord
  ##associations
	  belongs_to :invoice
	  belongs_to :course_registration
end
