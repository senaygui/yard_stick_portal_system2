class Assessment < ApplicationRecord
	after_save :generate_student_grade

	belongs_to :student_grade, optional: true
	belongs_to :student
	belongs_to :course

	def generate_student_grade
		if self.student.present?
			grade = StudentGrade.where(student_id: self.student_id).where(course_id: self.course_id).first
			if grade.present?
				self.update_column(:student_grade_id, grade.id)
			end
		end
	end


end
