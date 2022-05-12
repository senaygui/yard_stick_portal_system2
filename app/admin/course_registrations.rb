ActiveAdmin.register CourseRegistration do
  config.batch_actions = true
  permit_params :semester_registration,:curriculum,:enrollment_status,:course_title

  scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          enrollment_status: 'text',
                                          }
                                        end

  # controller do
  #   def scoped_collection
  #     super.where("enrollment_status = ?", "enrolled")
  #   end
  # end
  index do
    selectable_column
    column :student do |sd|
      sd.student.name.full if sd.student.present?
    end
    column :id do |c|
      c.semester_registration.student.student_id
    end
    column :course_title
    column :program do |c|
      c.semester_registration.program_name
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  filter :student_id_number
  filter :enrollment_status
  filter :course_title
  filter :created_by
  filter :created_at
  filter :updated_at
end
