class CourseRegistration < ApplicationRecord
	after_create :add_invoice_item
	after_create :add_grade
	##associations
	  belongs_to :semester_registration
	  belongs_to :curriculum
	  has_many :invoice_items
	  has_one :student_grade, dependent: :destroy


	private
		def add_invoice_item
			if (self.semester_registration.semester == 1) && (self.semester_registration.year == 1) && self.semester_registration.mode_of_payment.present? && self.semester_registration.invoices.last.nil?
				InvoiceItem.create do |invoice_item|
					invoice_item.invoice_id = self.semester_registration.invoice.id
					invoice_item.course_registration_id = self.id

					if self.semester_registration.mode_of_payment == "monthly"
						course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 4
					elsif self.semester_registration.mode_of_payment == "full"
						course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour
					elsif self.semester_registration.mode_of_payment == "half"
						course_price =  CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 2
					end
					invoice_item.price = course_price
				end
			end
		end

		def add_grade
			StudentGrade.create do |student_grade|
					student_grade.course_registration_id = self.id
					student_grade.student_id = self.semester_registration.student.id 
					student_grade.course_id = self.curriculum.course.id
				end
		end
end
