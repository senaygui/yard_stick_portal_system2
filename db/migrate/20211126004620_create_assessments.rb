class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments, id: :uuid do |t|
    	# t.belongs_to :student_grade, foreign_key: true, index: true, type: :uuid
    	t.string :assessment
    	t.decimal :result
      t.timestamps
    end
  end
end
