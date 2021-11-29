class SemesterRegistration < ApplicationRecord
	after_save :generate_invoice
	##validations
	  validates :semester, :presence => true
		validates :year, :presence => true
	##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :undergraduate, lambda { where(study_level: "undergraduate")}
  	scope :graduate, lambda { where(study_level: "graduate")}
  	scope :online, lambda { where(admission_type: "online")}
  	scope :regular, lambda { where(admission_type: "regular")}
  	scope :extention, lambda { where(admission_type: "extention")}
  	scope :distance, lambda { where(admission_type: "distance")}
	##associations
	  belongs_to :student
	  belongs_to :academic_calendar
	  has_many :course_registrations, dependent: :destroy
  	has_many :curriculums, through: :course_registrations, dependent: :destroy
  	# accepts_nested_attributes_for :course_registrations, reject_if: :all_blank, allow_destroy: true
  	has_many :invoices
  	has_one :grade_reports, dependent: :destroy

  	def generate_grade_report
  		GradeReport.create do |grade_report|
					grade_report.semester_registration_id = self.id
					grade_report.student_id = self.student.id
					grade_report.academic_calendar_id = self.academic_calendar.id
					grade_report.semester= self.student.semester
					grade_report.year= self.student.year
					sgp = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour * oi.student_grade.grade_letter_value) : 0 }.sum
					total_credit_hour = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour) : 0 }.sum
					grade_report.cgpa = sgp / total_credit_hour
					grade_report.sgpa = sgp / total_credit_hour
					if GradeRule.all.last.min_cgpa_value_to_pass <= grade_report.cgpa
						grade_report.academic_status = "Promoted"
					elsif GradeRule.all.last.min_cgpa_value_to_pass > grade_report.cgpa
						grade_report.academic_status = "failed"
					end
					
			end
  	end
  	private	
	  	def generate_invoice
	  		if (self.semester == 1) && (self.year == 1) && self.mode_of_payment.present? && self.invoices.last.nil?
	  			Invoice.create do |invoice|
	  				invoice.semester_registration_id = self.id
	  				invoice.student_id = self.student.id
	  				invoice.created_by = self.created_by
	  				invoice.due_date = self.created_at.day + 2.days 
	  				invoice.invoice_status = "pending"
						invoice.registration_fee = CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.registration_fee
						invoice.invoice_number = SecureRandom.random_number(1000..10000)
						if mode_of_payment == "Monthly Payment"
							tution_price = self.student.program.monthly_price
							invoice.total_price = tution_price + invoice.registration_fee
						elsif mode_of_payment == "Full Semester Payment"
							tution_price = self.student.program.full_semester_price
							invoice.total_price = tution_price + invoice.registration_fee
						elsif mode_of_payment == "Every Three Month Payment"
							tution_price = self.student.program.three_monthly_price
							invoice.total_price = tution_price + invoice.registration_fee
						elsif mode_of_payment == "Every Two Month Payment"
							tution_price = self.student.program.two_monthly_price
							invoice.total_price = tution_price + invoice.registration_fee
						end	
						
						# self.total_price = (self.course_registrations.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * oi.curriculum.credit_hour) : 0 }.sum) + CollegePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.registration_fee
	  			end
	  		end
	  	end
end
