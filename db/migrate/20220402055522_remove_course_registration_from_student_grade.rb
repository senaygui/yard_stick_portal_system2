class RemoveCourseRegistrationFromStudentGrade < ActiveRecord::Migration[5.2]
  def up
  	remove_column :student_grades, :course_registration_id
  	add_reference :student_grades, :curriculum_id, type: :uuid
  end
  def down
  	# add_reference :student_grades, :course_registration_id, type: :uuid
  end
end
