class AddStudentNameAndProgramToInvoice < ActiveRecord::Migration[5.2]
  def change
  	add_column :invoices, :student_name, :string
  	add_column :invoices, :program, :string
  	add_column :invoices, :department, :string
  end
end
