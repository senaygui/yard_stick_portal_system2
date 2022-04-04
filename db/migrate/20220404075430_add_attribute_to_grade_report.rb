class AddAttributeToGradeReport < ActiveRecord::Migration[5.2]
  def change
  	add_column :grade_reports, :previous_credit_hr_total, :decimal
  	add_column :grade_reports, :semester_credit_hr_total, :decimal
  	add_column :grade_reports, :previous_grade_point_total, :decimal
  	add_column :grade_reports, :previous_ang_total, :decimal
  	add_column :grade_reports, :previous_alg_total, :decimal
  end
end
