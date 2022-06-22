class GradeReport < ApplicationRecord
	after_save :add_semester_registration
  belongs_to :semester_registration
  belongs_to :student
  belongs_to :academic_calendar

  
	def add_semester_registration
		if !(self.semester_registration.present?)
			sem = SemesterRegistration.where(student_id: self.student_id).where(year: 1, semester: 1).first
			self.update_column(:semester_registration_id, sem.id)
		end
	end
end
