class RemoveNullFalseFromHouseNumber < ActiveRecord::Migration[5.2]
  def change
  	change_column :student_addresses, :house_number, :string, null: true
  end
end
