class AddStudentIdNumberToSemesterRegistration < ActiveRecord::Migration[5.2]
  def change
  	add_column :semester_registrations, :student_id_number, :string
  end
end
