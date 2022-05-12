class AddStudentToCourseRegistration < ActiveRecord::Migration[5.2]
  def change
  	add_reference :course_registrations, :student, type: :uuid
  	add_column :course_registrations, :student_id_number, :string
  end
end
