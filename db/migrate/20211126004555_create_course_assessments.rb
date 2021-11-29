class CreateCourseAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :course_assessments do |t|
    	t.belongs_to :curriculums, index: true
    	t.integer :weight
    	t.string :assessment
      t.timestamps
    end
  end
end
