class Assessment < ApplicationRecord
	after_save :generate_student_grade

	belongs_to :student_grade, optional: true
	belongs_to :student, optional: true
	belongs_to :course

	def generate_student_grade
		grade = StudentGrade.where(student_id: self.student_id).where(course_id: self.course_id).first.id
		self.update_column(:student_grade_id, grade)
	end


end
