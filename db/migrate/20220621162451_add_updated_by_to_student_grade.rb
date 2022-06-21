class AddUpdatedByToStudentGrade < ActiveRecord::Migration[5.2]
  def change
  	add_column :student_grades, :updated_by, :string
  end
end
