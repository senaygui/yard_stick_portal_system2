class PaymentTransaction < ApplicationRecord
	after_create :set_invoice_status
  after_save :create_notification
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

  def create_notification
    if self.finance_approval_status == "pending"
      Notification.create do |notification|
        notification.notifiable_type = 'student'
        notification.notification_status = 'payment_pending'
        notification.notifiable = self.invoice.student
        notification.notification_message = 'In this step transfer to the college account and submit transfer information.'
      end
    elsif self.finance_approval_status == "approved"
      Notification.create do |notification|
        notification.notifiable_type = 'student'
        notification.notification_status = 'payment_approved'
        notification.notifiable = self.invoice.student
        notification.notification_message = 'payment has been approved'
      end
    elsif self.finance_approval_status == "denied"
      Notification.create do |notification|
        notification.notifiable_type = 'student'
        notification.notification_status = 'payment_denied'
        notification.notifiable = self.invoice.student
        notification.notification_message = 'payment has been denied'
      end
    end
  end
end
