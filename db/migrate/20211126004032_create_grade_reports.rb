class CreateGradeReports < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_reports, id: :uuid do |t|
      # t.belongs_to :semester_registration, foreign_key: true, index: true, type: :uuid
      # t.belongs_to :student, foreign_key: true, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true
      t.decimal :cgpa
      t.decimal :sgpa
      t.integer :semester
      t.integer :year
      t.string :academic_status
      t.timestamps
    end
  end
end
