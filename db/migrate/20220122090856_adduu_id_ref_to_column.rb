class AdduuIdRefToColumn < ActiveRecord::Migration[5.2]
  def change
  	add_reference :course_registrations, :semester_registration, null: false, index: true, type: :uuid
  	
    add_reference :invoices, :semester_registration, null: false,  index: true, type: :uuid
    add_reference :invoices, :student, null: false,  index: true, type: :uuid

    add_reference :invoice_items, :invoice, null: false,  index: true, type: :uuid
    

    add_reference :payment_transactions, :invoice, null: false,  index: true, type: :uuid

    
    add_reference :student_grades, :student, null: false,  index: true, type: :uuid

    add_reference :grade_reports, :semester_registration, null: false,  index: true, type: :uuid
    add_reference :grade_reports, :student, null: false,  index: true, type: :uuid

    add_reference :assessments, :student_grade, null: false,  index: true, type: :uuid
  end
end
