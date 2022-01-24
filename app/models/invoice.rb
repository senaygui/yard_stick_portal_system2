class Invoice < ApplicationRecord
	after_create :add_invoice_item
	after_save :approve_semester_registration
	# after_update :update_total_price
	##validations
    validates :invoice_number , :presence => true
  ##associations
	  belongs_to :semester_registration
	  belongs_to :student
	  has_one :payment_transaction
	  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true
	  has_many :invoice_items, dependent: :destroy
	##scope
    scope :recently_added, lambda {where('created_at >= ?', 1.week.ago)}
    # scope :undergraduate, lambda { self.registration.where(study_level: "undergraduate")}
    # scope :graduate, lambda { self.registration.where(study_level: "graduate")}
    # scope :online, lambda { self.registration.where(admission_type: "online")}
    # scope :regular, lambda { self.registration.where(admission_type: "regular")}
    # scope :extention, lambda { self.registration.where(admission_type: "extention")}
    # scope :distance, lambda { self.registration.where(admission_type: "distance")}
    scope :pending, lambda { where(invoice_status: "pending")}
    scope :approved, lambda { where(invoice_status: "approved")}
    scope :denied, lambda { where(invoice_status: "denied")}
    scope :incomplete, lambda { where(invoice_status: "incomplete")}

	# def total_price
 #    self.invoice_items.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * oi.course_registration.curriculum.credit_hour) : 0 }.sum + self.registration_fee
 #  end
  
  private

  	def add_invoice_item
			self.semester_registration.course_registrations.each do |course|
				InvoiceItem.create do |invoice_item|
					invoice_item.invoice_id = self.id
					invoice_item.course_registration_id = course.id
					invoice_item.created_by = self.created_by
					if self.semester_registration.mode_of_payment == "monthly"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour / 4
						invoice_item.price = course_price
					elsif self.semester_registration.mode_of_payment == "full"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour
						invoice_item.price = course_price
					elsif self.semester_registration.mode_of_payment == "half"
						course_price =  CollegePayment.where(study_level: self.semester_registration.study_level,admission_type: self.semester_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour / 2
						invoice_item.price = course_price
					end
					
				end
			end
		end

		def approve_semester_registration
			if self.payment_transaction.present? && self.payment_transaction.finance_approval_status == "approved"
				self.semester_registration.update_column(registrar_approval_status = "approved")
      	self.semester_registration.update_column(finance_approval_status = "approved")

    	end
		end

	  # def update_semester_registration
	  #   self[:total_price] = total_price
	  # end
end
