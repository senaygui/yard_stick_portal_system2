# frozen_string_literal: true

class DeviseCreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ##student information
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :gender, null: false
      t.string :student_id, :unique =>  true
      t.datetime :date_of_birth, null: false
      t.belongs_to :program, index: true
      t.string :department
      t.string :admission_type, null: false
      t.string :study_level, null: false
      t.string :marital_status
      t.integer :year, default: 1
      t.integer :semester, default: 1 
      t.string :account_verification_status, default: "pending"
      t.string :document_verification_status, default: "pending"
      t.string :account_status, default: "active"
      t.string :graduation_status
      t.string :current_occupation
      t.string :student_password
      t.boolean :tempo_status, default: false
      t.string :current_location
      ##created and updated by
      t.string :created_by, default: "self"
      t.string :last_updated_by
      t.timestamps null: false
    end

    add_index :students, :email,                unique: true
    add_index :students, :reset_password_token, unique: true
    # add_index :students, :confirmation_token,   unique: true
    # add_index :students, :unlock_token,         unique: true
  end
end
