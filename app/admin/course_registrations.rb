ActiveAdmin.register CourseRegistration do
  config.batch_actions = true
  permit_params :semester_registration,:curriculum,:enrollment_status,:course_title

  scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          created_by: 'text',
                                          }
                                        end

  # controller do
  #   def scoped_collection
  #     super.where("enrollment_status = ?", "enrolled")
  #   end
  # end
  index do
    selectable_column
    column :student_full_name
    column :id do |c|
      c.student.student_id
    end
    column :course_title
    column :program do |c|
      c.program.program_name
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
end
