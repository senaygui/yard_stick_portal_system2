class AddStudentAndCourseToAssessment < ActiveRecord::Migration[5.2]
  def change
  	add_reference :assessments, :student, type: :uuid
  	add_reference :assessments, :course
  end
end
