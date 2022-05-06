ActiveAdmin.register Assessment do
  permit_params :student_grade_id, :assessment, :result, :student_id, :course_id
  scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          assessment: 'text'
                                          }
                                        end
   active_admin_import validate: true,
                      headers_rewrites: { 'ID': :student_id },
                      before_batch_import: ->(importer) {
                        student_ids = importer.values_at(:student_id)
                        # replacing author name with author id
                        students   = Student.where(student_id: student_ids).pluck(:student_id, :id)
                        options = Hash[*students.flatten] # #{"Jane" => 2, "John" => 1}
                        importer.batch_replace(:student_id, options)
                      }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  #
  # or
  #
  # permit_params do
  #   permitted = [:student_grade_id, :assessment, :result]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
