class CreateCurriculums < ActiveRecord::Migration[5.2]
  def change
    create_table :curriculums do |t|
      t.belongs_to :program, index: true
      t.belongs_to :course, index: true
      t.integer :semester, null: false, default: 1
      t.datetime :course_starting_date
      t.datetime :course_ending_date
      t.integer :year, null: false, default: 1
      t.integer :credit_hour, null: false
      t.integer :ects
      t.decimal :full_course_price, default: 0.0
      t.decimal :monthly_course_price, default: 0.0
      t.string :course_title
      ##created and updated by
      t.string :created_by
      t.string :last_updated_by
      t.timestamps
    end
  end
end
