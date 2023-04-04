class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :notifiable, polymorphic: true, type: :uuid
      t.string :notification_status, null: false
      t.string :notification_message
      t.timestamps
    end
  end
end
