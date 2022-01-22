class CreateStudentGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :student_grades, id: :uuid  do |t|
      t.belongs_to :course_registration, index: true
      # t.belongs_to :student, foreign_key: true, index: true, type: :uuid
      t.string :grade_in_letter
      t.string :grade_in_number
      t.decimal :grade_letter_value
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
