class AddCurrentLocation < ActiveRecord::Migration[5.2]
  def change
  	add_column :students, :current_location, :string
  end
end
