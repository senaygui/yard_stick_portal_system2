class CreateStudentAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :student_addresses do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.string :country, null: false
      t.string :city, null: false
      t.string :region
      t.string :zone, null: false
      t.string :sub_city
      t.string :house_number
      t.string :cell_phone, null: false
      t.string :house_phone
      t.string :pobox
      t.string :woreda, null: false
      ##created and updated by
      t.string :created_by, default: "self"
      t.string :last_updated_by
      t.timestamps
    end
  end
end
