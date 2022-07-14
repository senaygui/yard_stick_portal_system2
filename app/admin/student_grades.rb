ActiveAdmin.register StudentGrade do
  config.sort_order = "created_at_desc"
  permit_params :course_registration_id,:student_id,:grade_in_letter,:grade_in_number,:course_id,assessments_attributes: [:id,:assessment,:result, :_destroy]

   active_admin_import validate: true,
                      headers_rewrites: { 'ID': :student_id },
                      before_batch_import: ->(importer) {
                        student_ids = importer.values_at(:student_id)
                        # replacing author name with author id
                        students   = Student.where(student_id: student_ids).pluck(:student_id, :id)
                        options = Hash[*students.flatten] # #{"Jane" => 2, "John" => 1}
                        importer.batch_replace(:student_id, options)
                      }
  scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          updated_by: 'text'
                                          }
                                        end

  member_action :get_grade_from_lms, method: :put do
    @student_grade= StudentGrade.find(params[:id])
    @student_grade.moodle_grade
    redirect_back(fallback_location: admin_student_grade_path)
  end
  batch_action "Generate Grade for", method: :put, confirm: "Are you sure?" do |ids|
    StudentGrade.find(ids).each do |student_grade|
      student_grade.moodle_grade
    end
    redirect_to collection_path, notice: "Grade Is Generated Successfully"
  end
  action_item :update, only: :show do
    link_to 'get grade from lms', get_grade_from_lms_admin_student_grade_path(student_grade.id), method: :put, data: { confirm: 'Are you sure?' }        
  end
                    
  member_action :generate_grade, method: :put do
    @student_grade= StudentGrade.find(params[:id])
    @student_grade.generate_grade
    redirect_back(fallback_location: admin_student_grade_path)
  end
  action_item :update, only: :show do
    link_to 'generate grade', generate_grade_admin_student_grade_path(student_grade.id), method: :put, data: { confirm: 'Are you sure?' }        
  end
  index do
    selectable_column
    column "full name", sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}" 
    end
    column "Student ID" do |si|
      si.student.student_id
    end
    column "Course title" do |si|
      si.course.course_title
    end
    column :grade_in_letter
    column :grade_letter_value
    column :grade_in_number
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
         fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :grade_in_letter
  filter :grade_in_number, as: :numeric_range_filter
  filter :created_at
  filter :updated_at


  
  form do |f|
    f.semantic_errors

    if f.object.assessments.empty?
      f.object.assessments << Assessment.new
    end
    panel "Assessment" do
      f.has_many :assessments,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
        a.input :assessment
        a.input :result
        a.label :_destroy
      end
    end
    f.actions
  end

  show :title => proc{|student| student.student.name.full } do
    panel "Grade information" do
      attributes_table_for student_grade do
        row "full name", sortable: true do |n|
          n.student.name.full 
        end
        row "Student ID" do |si|
          si.student.student_id
        end
        row "Course title" do |si|
          si.course.course_title
        end
        row "Program" do |pr|
          link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
        end
        row :grade_in_letter
        row :grade_letter_value
        row :grade_in_number
        row :created_at
        row :updated_at
      end
    end
    panel "Assessments Information" do
      table_for student_grade.assessments do
        column :assessment
        column :result
        column :created_at
        column :updated_at
      end
    end
  end 
  
end
