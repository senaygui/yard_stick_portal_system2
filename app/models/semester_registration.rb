class SemesterRegistration < ApplicationRecord
	after_save :create_notification_two
	after_save :generate_invoice
	after_save :generate_invoice_senier_students
	# after_save :generate_grade_report
	after_save :add_course_for_reg
	# after_save :second_semester_course
	after_create :first_semester_course
	after_save :set_student_id_number
	after_save :add_grade
	
	# after_save :first_semester_course_for_import
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
  	has_many :invoices, dependent: :destroy
  	has_one :grade_report, dependent: :destroy



  # def create_notification 
  #   if self.mode_of_payment.present? && self.invoices.empty? 
  #     Notification.create do |notification|
  #       notification.notifiable_type = 'student'
  #       notification.notification_status = 'payment_submit'
  #       notification.notifiable = self.student
  #       notification.notification_message = 'In this step transfer to the college account and submit transfer information.'
  #     end
  #   end
  # end
  def create_notification_two
  	if self.document_verification_status == "approved" && (self.remaining_amount == 6678)
      Notification.create do |notification|
        notification.notifiable_type = 'student'
        notification.notification_status = 'approved'
        notification.notifiable = self
        notification.notification_message = 'Your account has been Approved. Click the enroll button to enroll courses.'
      end
    end
  end

  def generate_grade_report
  	
  	if !self.grade_report.present?
	  	GradeReport.create do |report|
	  			report.semester_registration_id = self.id
					report.student_id = self.student.id
					report.academic_calendar_id = self.academic_calendar.id
					report.semester = self.semester
					report.year = self.year
					

					if !self.student.grade_reports.present?
						# report.total_course = self.course_registrations.count
						report.semester_credit_hr_total = self.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.curriculum.credit_hour) : 0 }.sum 
						report.semester_total_grade_point = self.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.student_grade.grade_in_number.to_f) : 0 }.sum 
						report.sgpa = report.semester_credit_hr_total == 0 ? 0 : (report.semester_total_grade_point / report.semester_credit_hr_total).round(1) 

						report.cumulative_total_credit_hour = report.semester_total_grade_point
						report.cumulative_total_grade_point = report.semester_total_grade_point
						report.cgpa = report.semester_credit_hr_total == 0 ? 0 : (report.semester_total_grade_point / report.semester_credit_hr_total).round(1)
						report.academic_status = "Incomplete"
						if ((self.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("I")) || (self.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("NG")))
							report.academic_status = "Incomplete"
						else
							# report.academic_status = AcademicStatus.where("min_value < ?", report.cgpa).where("max_value > ?", report.cgpa).last.status
							# if (report.academic_status != "Dismissal") || (report.academic_status != "Incomplete")
							# 	if self.program.program_semester > self.student.semester
							# 		promoted_semester = self.student.semester + 1
							# 		self.student.update_columns(semester: promoted_semester)
							# 	elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
							# 		promoted_year = self.student.year + 1
							# 		self.student.update_columns(semester: 1)
							# 		self.student.update_columns(year: promoted_year)
							# 	end
							# end
						end
					elsif self.student.grade_reports.present?
						report.semester_credit_hr_total = self.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.curriculum.credit_hour) : 0 }.sum 
						report.semester_total_grade_point = self.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.student_grade.grade_in_number.to_f) : 0 }.sum 
						report.sgpa = report.semester_credit_hr_total == 0 ? 0 : (report.semester_total_grade_point / report.semester_credit_hr_total).round(1) 

						report.cumulative_total_credit_hour = self.student.grade_reports.order("created_at DESC").first.cumulative_total_credit_hour + report.semester_credit_hr_total
						report.cumulative_total_grade_point = self.student.grade_reports.order("created_at DESC").first.cumulative_total_grade_point + report.semester_total_grade_point
						report.cgpa = report.cumulative_total_grade_point / report.cumulative_total_credit_hour

						if ((self.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("I")) || (self.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("NG")))
							report.academic_status = "Incomplete"
						else
							# report.academic_status = AcademicStatus.where("min_value <= ?", report.cgpa).where("max_value >= ?", report.cgpa).last.status
							# if (report.academic_status != "Dismissal") || (report.academic_status != "Incomplete")
							# 	if self.program.program_semester > self.student.semester
							# 		promoted_semester = self.student.semester + 1
							# 		self.student.update_columns(semester: promoted_semester)
							# 	elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
							# 		promoted_year = self.student.year + 1
							# 		self.student.update_columns(semester: 1)
							# 		self.student.update_columns(year: promoted_year)
							# 	end
							# end
						end
					end
					
					# report.created_by = self.created_by			
			end	
		end
  end

  # def generate_grade_report
  # 	if (self.course_registrations.joins(:student_grade).present?)
  # 		GradeReport.create do |grade_report|
		# 			grade_report.semester_registration_id = self.id
		# 			grade_report.student_id = self.student.id
		# 			grade_report.academic_calendar_id = 3
		# 			grade_report.semester = self.semester
		# 			grade_report.year = self.year

		# 			sgp = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour * oi.student_grade.grade_in_number.to_f) : 0 }.sum
		# 			total_credit_hour = course_registrations.collect { |oi| oi.valid? ? (oi.curriculum.credit_hour) : 0 }.sum

		# 			grade_report.sgpa = sgp / total_credit_hour
		# 			grade_report.semester_credit_hr_total =  total_credit_hour
		# 			grade_report.semester_total_grade_point = course_registrations.collect { |oi| oi.valid? ? oi.semester_registration.student.student_grades.where(course_id: oi.curriculum.course_id).last.grade_in_number.to_f : 0 }.sum

		# 			if self.student.grade_reports.count > 1
		# 				ss
		# 				grade_report.previous_credit_hr_total = self.student.grade_reports.order("created_at DESC").first.semester_credit_hr_total
		# 				grade_report.previous_grade_point_total = self.student.grade_reports.order("created_at DESC").first.semester_total_grade_point
		# 				grade_report.previous_ang_total = self.student.grade_reports.order("created_at DESC").first.cgpa

		# 				grade_report.cgpa = (grade_report.sgpa + grade_report.previous_ang_total) / 2
		# 				grade_report.cumulative_total_credit_hour = (grade_report.semester_credit_hr_total + grade_report.previous_credit_hr_total)
		# 				grade_report.cumulative_total_grade_point = (grade_report.semester_total_grade_point + grade_report.previous_grade_point_total)
		# 			else
		# 				grade_report.cgpa = grade_report.sgpa 
		# 				grade_report.cumulative_total_credit_hour = grade_report.semester_credit_hr_total
		# 				grade_report.cumulative_total_grade_point = grade_report.semester_total_grade_point
		# 			end
		# 	end
		# end
  # end


  def add_course_for_reg
  	if (self.remaining_amount == 6677) && (!self.course_registrations.present?)
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
	  	def generate_invoice_senier_students
	  		if (self.mode_of_payment.present?) && (self.invoices.empty?) && (self.year == 2) && (self.semester == 2)
	  			Invoice.create do |invoice|
	  				invoice.semester_registration_id = self.id
	  				invoice.student_id = self.student.id
	  				invoice.created_by = self.created_by
	  				invoice.due_date = self.created_at.day + 2.days 
	  				invoice.student_name = "#{self.student.first_name} #{self.student.middle_name} #{self.student.last_name}"
	  				invoice.department = self.student.department
	  				invoice.program = self.student.program.program_name
	  				invoice.invoice_status = "not submitted"
					invoice.registration_fee = 250
						invoice.invoice_number = SecureRandom.random_number(10000000)
						if mode_of_payment == "Monthly Payment"
							tution_price = 6500
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

	  	def first_semester_course_for_import
	  		if (self.remaining_amount == 35) && (self.course_registrations.empty?) && (self.semester == 1) && (self.year == 1)
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

	  	def set_student_id_number
	  		if !self.student_id_number.present?
	  			self.update_columns(student_id_number: self.student.student_id)
	  		end
	  	end

	  def add_grade
			if (self.registrar_approval_status == "approved")
				self.course_registrations.each do |reg|
					if (!reg.student_grade.present?)
						StudentGrade.create do |student_grade|
								student_grade.course_registration_id = reg.id
								student_grade.student_id = self.student.id 
								student_grade.course_id = reg.curriculum.course.id
						end
					end
				end
			end
		end
end
