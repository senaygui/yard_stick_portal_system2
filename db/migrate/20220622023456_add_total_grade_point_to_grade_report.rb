class AddTotalGradePointToGradeReport < ActiveRecord::Migration[5.2]
  def change
  	add_column :grade_reports, :semester_total_grade_point, :decimal
  	add_column :grade_reports, :cumulative_total_credit_hour, :decimal
  	add_column :grade_reports, :cumulative_total_grade_point, :decimal
  end
end
