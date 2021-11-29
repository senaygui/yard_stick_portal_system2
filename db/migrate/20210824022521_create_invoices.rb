class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.belongs_to :semester_registration, index: true
      t.belongs_to :student, index: true
      t.string :invoice_number, null: false
      t.decimal :total_price
      t.decimal :registration_fee, default: 0
			t.decimal :late_registration_fee, default: 0
			t.decimal :penalty, default: 0
			t.decimal :daily_penalty, default: 0
			t.string :invoice_status , default: "not paid"
			t.string :last_updated_by
      t.string :created_by
      t.datetime :due_date
      t.timestamps
    end
  end
end
