class AddPriceToProgram < ActiveRecord::Migration[5.2]
  def change
  	add_column :programs, :monthly_price, :decimal
  	add_column :programs, :full_semester_price, :decimal
  	add_column :programs, :two_monthly_price, :decimal
  	add_column :programs, :three_monthly_price, :decimal
  end
end
