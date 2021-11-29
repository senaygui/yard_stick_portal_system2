class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
    	t.belongs_to :department, index: true
    	t.string :program_name, null:false
      t.string :program_code, null:false
    	t.string :study_level, null: false
    	t.string :admission_type, null: false
    	t.text :overview
    	t.text :program_description
      t.integer :total_semester, null: false
    	t.integer :program_duration, null: false
      t.integer :program_semester, null: false
      t.decimal :total_tuition, default: 0.0
    	t.string :created_by
    	t.string :last_updated_by
      t.timestamps
    end
  end
end
