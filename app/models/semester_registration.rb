class SemesterRegistration < ApplicationRecord
	after_save :generate_invoice
	# after_save :generate_grade_report
	# after_save :add_course_for_reg
	after_save :second_semester_course
	after_create :first_semester_course
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
  	has_one :grade_report

  def generate_grade_report
  	if (self.remaining_amount == 5)
  		GradeReport.create do |grade_report|
					grade_report.semester_registration_id = self.id
					grade_report.student_id = self.student.id
					grade_report.academic_calendar_id = 3
					grade_report.semester= 1
					grade_report.year= 1
					sgp = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour * oi.semester_registration.student.student_grades.where(course_id: oi.curriculum.course_id).last.grade_letter_value) : 0 }.sum
					total_credit_hour = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour) : 0 }.sum
					grade_report.cgpa = sgp / total_credit_hour
					grade_report.sgpa = sgp / total_credit_hour
					if GradeRule.all.last.min_cgpa_value_to_pass <= grade_report.cgpa
						grade_report.academic_status = "Promoted"
					elsif 2.5 > grade_report.cgpa
						grade_report.academic_status = "Probation"
					elsif GradeRule.all.last.min_cgpa_value_to_pass > grade_report.cgpa
						grade_report.academic_status = "Failed"
					end
					
			end
		end
  end

  # def add_course_for_reg
  # 	if (self.remaining_amount == 3) && (self.course_registrations.empty?) && (self.semester == 1)
  # 		self.student.program.curriculums.where(year: 1, semester: 1).each do |co|
  # 			CourseRegistration.create do |course|
  # 				course.semester_registration_id = self.id
  # 				course.curriculum_id = co.id
  # 				course.course_title = co.course.course_title
		# 	    # course.course_title = co.course.course_title
		# 	  end
		# 	end
  # 	end
  # end
  private	
	  	def generate_invoice
	  		if self.mode_of_payment.present? && self.invoices.empty?
	  			Invoice.create do |invoice|
	  				invoice.semester_registration_id = self.id
	  				invoice.student_id = self.student.id
	  				invoice.created_by = self.created_by
	  				invoice.due_date = self.created_at.day + 2.days 
	  				invoice.student_name = "#{self.student.first_name} #{self.student.middle_name} #{self.student.last_name}"
	  				invoice.department = self.student.department
	  				invoice.program = self.student.program.program_name
	  				invoice.invoice_status = "not submitted"
	  				if (self.semester == 1) && (self.year == 1)
							invoice.registration_fee = 550
						else
							invoice.registration_fee = 250
						end
						invoice.invoice_number = SecureRandom.random_number(10000000)
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

	  	def first_semester_course
	  		if (self.course_registrations.empty?) && (self.semester == 1) && (self.year == 1)
			    self.student.program.curriculums.where(year: self.student.year, semester: self.student.semester).each do |co|
			      CourseRegistration.create do |course|
			        course.semester_registration_id = self.id
			        course.curriculum_id = co.id
			        course.course_title = co.course.course_title
			        # course.course_title = co.course.course_title
			      end
			    end
			  end
	  	end
	  	def second_semester_course
	  		if (self.course_registrations.empty?) && (self.semester == 2) && (self.remaining_amount == 9)
			    self.student.program.curriculums.where(year: self.year, semester: self.semester).each do |co|
			      CourseRegistration.create do |course|
			        course.semester_registration_id = self.id
			        course.curriculum_id = co.id
			        course.course_title = co.course.course_title
			        # course.course_title = co.course.course_title
			      end
			    end
			  end
	  	end
end
