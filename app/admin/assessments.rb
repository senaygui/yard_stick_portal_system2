ActiveAdmin.register Assessment do
  config.sort_order = "created_at_asc"
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
  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
         fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
         order_by: 'id_asc'



  index do
    selectable_column
    column :student_grade_id
    column "student name", sortable: true do |n|
      if n.student.present?
        "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
      end
    end
    column "Student ID" do |si|
      if n.student.present?
        si.student.student_id
      end
    end
    column "Course" do |si|
      if si.course.present?
        si.course.course_title
      end
    end
    column :assessment
    column :result
    column "Updated At", sortable: true do |c|
      c.updated_at.strftime("%b %d, %Y")
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :assessment
  filter :result
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs "Assessment information" do
      f.input :student_id, as: :search_select, url: admin_students_path,
          fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :course_id, as: :search_select, url: admin_courses_path,
          fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :assessment
      f.input :result
            
    end
    f.actions
  end
  
end
