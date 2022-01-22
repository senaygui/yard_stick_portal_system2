class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      # t.belongs_to :invoice, foreign_key: true, index: true, type: :uuid
      t.belongs_to :course_registration, foreign_key: true, index: true
      t.decimal :price, default: 0
      t.string :last_updated_by
      t.string :created_by
      t.timestamps
    end
  end
end
