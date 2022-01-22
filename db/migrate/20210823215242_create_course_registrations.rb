class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :course_registrations do |t|
      # t.belongs_to :semester_registration, foreign_key: true, index: true, type: :uuid
      t.belongs_to :curriculum, index: true
      t.string :enrollment_status, default:"pending"
      t.string :course_title
      t.timestamps
    end
  end
end
