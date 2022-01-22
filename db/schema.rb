# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_22_090856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "academic_calendars", force: :cascade do |t|
    t.string "calender_year", null: false
    t.datetime "starting_date", null: false
    t.datetime "ending_date", null: false
    t.string "admission_type", null: false
    t.string "study_level", null: false
    t.integer "from_year"
    t.integer "to_year"
    t.string "remark"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "academic_calendar_id"
    t.string "activity", null: false
    t.integer "semester", null: false
    t.string "description"
    t.string "category", null: false
    t.datetime "starting_date", null: false
    t.datetime "ending_date", null: false
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_calendar_id"], name: "index_activities_on_academic_calendar_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "role", default: "admin", null: false
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "assessments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "assessment"
    t.decimal "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "student_grade_id", null: false
    t.index ["student_grade_id"], name: "index_assessments_on_student_grade_id"
  end

  create_table "college_payments", force: :cascade do |t|
    t.string "study_level", null: false
    t.string "admission_type", null: false
    t.string "student_nationality"
    t.decimal "total_fee", default: "0.0"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "daily_late_registration_penalty", default: "0.0"
    t.decimal "makeup_exam_fee", default: "0.0"
    t.decimal "add_drop", default: "0.0"
    t.decimal "tution_per_credit_hr", default: "0.0"
    t.decimal "readmission", default: "0.0"
    t.decimal "reissuance_of_grade_report", default: "0.0"
    t.decimal "student_copy", default: "0.0"
    t.decimal "additional_student_copy", default: "0.0"
    t.decimal "tempo", default: "0.0"
    t.decimal "original_certificate", default: "0.0"
    t.decimal "original_certificate_replacement", default: "0.0"
    t.decimal "tempo_replacement", default: "0.0"
    t.decimal "letter", default: "0.0"
    t.decimal "student_id_card", default: "0.0"
    t.decimal "student_id_card_replacement", default: "0.0"
    t.decimal "name_change", default: "0.0"
    t.decimal "transfer_fee", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colleges", force: :cascade do |t|
    t.string "college_name", null: false
    t.text "background"
    t.text "mission"
    t.text "vision"
    t.text "overview"
    t.string "headquarter"
    t.string "sub_city"
    t.string "state"
    t.string "region"
    t.string "zone"
    t.string "worda"
    t.string "city"
    t.string "country"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_assessments", force: :cascade do |t|
    t.bigint "curriculums_id"
    t.integer "weight"
    t.string "assessment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curriculums_id"], name: "index_course_assessments_on_curriculums_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "module_title", null: false
    t.bigint "department_id"
    t.string "module_code", null: false
    t.text "overview"
    t.text "description"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_course_modules_on_department_id"
  end

  create_table "course_registrations", force: :cascade do |t|
    t.bigint "curriculum_id"
    t.string "enrollment_status", default: "pending"
    t.string "course_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "semester_registration_id", null: false
    t.index ["curriculum_id"], name: "index_course_registrations_on_curriculum_id"
    t.index ["semester_registration_id"], name: "index_course_registrations_on_semester_registration_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "course_module_id"
    t.string "course_title", null: false
    t.string "course_code", null: false
    t.text "course_description"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_module_id"], name: "index_courses_on_course_module_id"
  end

  create_table "curriculums", force: :cascade do |t|
    t.bigint "program_id"
    t.bigint "course_id"
    t.integer "semester", default: 1, null: false
    t.datetime "course_starting_date"
    t.datetime "course_ending_date"
    t.integer "year", default: 1, null: false
    t.integer "credit_hour", null: false
    t.integer "ects"
    t.decimal "full_course_price", default: "0.0"
    t.decimal "monthly_course_price", default: "0.0"
    t.string "course_title"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_curriculums_on_course_id"
    t.index ["program_id"], name: "index_curriculums_on_program_id"
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "college_id"
    t.string "department_name"
    t.text "overview"
    t.text "background"
    t.text "facility"
    t.string "location"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "telegram_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_departments_on_college_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.uuid "student_id"
    t.string "full_name", null: false
    t.string "relationship"
    t.string "cell_phone", null: false
    t.string "email"
    t.string "current_occupation"
    t.string "name_of_current_employer"
    t.string "pobox"
    t.string "email_of_employer"
    t.string "office_phone_number"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_emergency_contacts_on_student_id"
  end

  create_table "grade_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "academic_calendar_id"
    t.decimal "cgpa"
    t.decimal "sgpa"
    t.integer "semester"
    t.integer "year"
    t.string "academic_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "semester_registration_id", null: false
    t.uuid "student_id", null: false
    t.index ["academic_calendar_id"], name: "index_grade_reports_on_academic_calendar_id"
    t.index ["semester_registration_id"], name: "index_grade_reports_on_semester_registration_id"
    t.index ["student_id"], name: "index_grade_reports_on_student_id"
  end

  create_table "grade_rules", force: :cascade do |t|
    t.string "admission_type"
    t.string "study_level"
    t.integer "min_cgpa_value_to_pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grades", force: :cascade do |t|
    t.bigint "grade_rule_id"
    t.string "grade"
    t.integer "min_value"
    t.integer "max_value"
    t.integer "grade_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_rule_id"], name: "index_grades_on_grade_rule_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "course_registration_id"
    t.decimal "price", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invoice_id", null: false
    t.index ["course_registration_id"], name: "index_invoice_items_on_course_registration_id"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoice_number", null: false
    t.decimal "total_price"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "penalty", default: "0.0"
    t.decimal "daily_penalty", default: "0.0"
    t.string "invoice_status", default: "not paid"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "semester_registration_id", null: false
    t.uuid "student_id", null: false
    t.index ["semester_registration_id"], name: "index_invoices_on_semester_registration_id"
    t.index ["student_id"], name: "index_invoices_on_student_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "bank_name", null: false
    t.string "account_full_name", null: false
    t.string "account_number"
    t.string "phone_number"
    t.string "account_type"
    t.string "payment_method_type", null: false
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "payment_method_id"
    t.string "account_holder_fullname", null: false
    t.string "phone_number"
    t.string "account_number"
    t.string "transaction_reference"
    t.string "finance_approval_status", default: "pending"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invoice_id", null: false
    t.index ["invoice_id"], name: "index_payment_transactions_on_invoice_id"
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
  end

  create_table "programs", force: :cascade do |t|
    t.bigint "department_id"
    t.string "program_name", null: false
    t.string "program_code", null: false
    t.string "study_level", null: false
    t.string "admission_type", null: false
    t.text "overview"
    t.text "program_description"
    t.integer "total_semester", null: false
    t.integer "program_duration", null: false
    t.integer "program_semester", null: false
    t.decimal "total_tuition", default: "0.0"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "monthly_price"
    t.decimal "full_semester_price"
    t.decimal "two_monthly_price"
    t.decimal "three_monthly_price"
    t.index ["department_id"], name: "index_programs_on_department_id"
  end

  create_table "semester_registrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.string "program_name"
    t.string "admission_type"
    t.string "study_level"
    t.bigint "academic_calendar_id"
    t.decimal "total_price", default: "0.0"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.decimal "remaining_amount", default: "0.0"
    t.string "mode_of_payment"
    t.integer "semester", null: false
    t.integer "year", null: false
    t.integer "total_enrolled_course"
    t.string "registrar_approval_status", default: "pending"
    t.string "finance_approval_status", default: "pending"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_calendar_id"], name: "index_semester_registrations_on_academic_calendar_id"
    t.index ["student_id"], name: "index_semester_registrations_on_student_id"
  end

  create_table "student_addresses", force: :cascade do |t|
    t.uuid "student_id"
    t.string "country", null: false
    t.string "city", null: false
    t.string "region"
    t.string "zone", null: false
    t.string "sub_city"
    t.string "house_number"
    t.string "cell_phone", null: false
    t.string "house_phone"
    t.string "pobox"
    t.string "woreda", null: false
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_student_addresses_on_student_id"
  end

  create_table "student_grades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "course_registration_id"
    t.string "grade_in_letter"
    t.string "grade_in_number"
    t.decimal "grade_letter_value"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "student_id", null: false
    t.index ["course_id"], name: "index_student_grades_on_course_id"
    t.index ["course_registration_id"], name: "index_student_grades_on_course_registration_id"
    t.index ["student_id"], name: "index_student_grades_on_student_id"
  end

  create_table "students", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "gender", null: false
    t.string "student_id"
    t.datetime "date_of_birth", null: false
    t.bigint "program_id"
    t.string "department"
    t.string "admission_type", null: false
    t.string "study_level", null: false
    t.string "marital_status"
    t.integer "year", default: 1
    t.integer "semester", default: 1
    t.string "account_verification_status", default: "pending"
    t.string "document_verification_status", default: "pending"
    t.string "account_status", default: "active"
    t.string "graduation_status"
    t.string "current_occupation"
    t.string "student_password"
    t.boolean "tempo_status", default: false
    t.string "current_location"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["program_id"], name: "index_students_on_program_id"
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
