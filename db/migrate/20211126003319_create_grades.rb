class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades do |t|
    	t.belongs_to :grade_rule, index: true
    	t.string :grade
    	t.integer :min_value
    	t.integer :max_value
    	t.integer :grade_value
      t.timestamps
    end
  end
end
