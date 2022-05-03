ActiveAdmin.register SemesterRegistration do
  config.sort_order = "created_at_desc"
  menu priority: 9
  permit_params :student_id,:total_price,:registration_fee,:late_registration_fee,:remaining_amount,:mode_of_payment,:semester,:year,:total_enrolled_course,:academic_calendar_id,:registrar_approval_status,:finance_approval_status,:created_by,:last_updated_by, curriculum_ids: []
    scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          remaining_amount: 'text'
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
  csv do
    column "username" do |username|
      username.student.student_id
    end
    column "password" do |pass|
      pass.student.student_password
    end
    column "firstname" do |fn|
      fn.student.first_name
    end
    column "lastname" do |ln|
      ln.student.last_name
    end
    column "email" do |e|
      e.student.email
    end
    column "course1" do |e|
      e.course_registrations[0].curriculum.course.course_code if e.course_registrations[0]
    end
    column "role1" do |e|
      "student"
    end
    column "course2" do |e|
       e.course_registrations[1].curriculum.course.course_code if e.course_registrations[1]
    end
    column "role2" do |e|
      "student"
    end
    column "course3" do |e|
       e.course_registrations[2].curriculum.course.course_code if e.course_registrations[2]
    end
    column "role3" do |e|
      "student"
    end
    column "course4" do |e|
       e.course_registrations[3].curriculum.course.course_code if e.course_registrations[3]
    end
    column "role4" do |e|
      "student"
    end
    column "course5" do |e|
       e.course_registrations[4].curriculum.course.course_code if e.course_registrations[4]
    end
    column "role5" do |e|
      "student"
    end
    column "course6" do |e|
       e.course_registrations[5].curriculum.course.course_code if e.course_registrations[5]
    end
    column "role6" do |e|
      "student"
    end
  end
  controller do
    def create
      super do |format|
      if @CollegePayment.save
        format.html { redirect_to edit_admin_semester_registration_path(@semester_registration), notice: 'student registration created successfully.' }
        format.json { render :show, status: :created, location: @semester_registration }
      else
        format.html { render :new }
        format.json { render json: @semester_registration.errors, status: :unprocessable_entity }
      end
    end
      # super
    end 
  end 
  member_action :generate_grade_report, method: :put do
    @semester_registration= SemesterRegistration.find(params[:id])
    @semester_registration.generate_grade_report
    redirect_back(fallback_location: admin_student_grade_path)
  end
  action_item :update, only: :show do
    link_to 'generate grade report', generate_grade_report_admin_semester_registration_path(semester_registration.id), method: :put, data: { confirm: 'Are you sure?' }        
  end

  index do
    selectable_column
    column "student name", sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column :admission_type
    column :study_level
    column "academic year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column :semester
    column :year
    column "approval status", sortable: true do |c|
      status_tag c.registrar_approval_status
    end
    # column :mode_of_payment
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :academic_calendar_id, as: :search_select_filter, url: proc { admin_academic_calendars_path },
         fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :mode_of_payment
  filter :semester
  filter :year
  filter :admission_type
  filter :study_level
  filter :program_name
  filter :registrar_approval_status
  filter :finance_approval_status
  filter :remaining_amount
  filter :last_updated_by
  filter :created_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :undergraduate
  scope :graduate
  scope :online, :if => proc { current_admin_user.role == "admin" }
  scope :regular, :if => proc { current_admin_user.role == "admin" }
  scope :extention, :if => proc { current_admin_user.role == "admin" }
  scope :distance, :if => proc { current_admin_user.role == "admin" }
  
  form do |f|
    f.semantic_errors
    if !f.object.new_record?
      panel "Student Information" do
        attributes_table_for semester_registration do
            # row "photo" do |pt|
            #   span image_tag(pt.student.photo, size: '150x150', class: "img-corner")
            # end
            row "full name", sortable: true do |n|
              "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
            end
            row "Student ID" do |si|
              si.student.student_id
            end
            row "Program" do |pr|
              link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
            end
            row "Department" do |si|
              si.student.department
            end
            row :admission_type do |si|
              si.student.admission_type
            end
            row :study_level do |si|
              si.student.study_level
            end
            row :year do |si|
              si.student.year
            end
            # row :department
            # row :admission_type
            # row :study_level
            # row :year
        end
      end
      panel "course registrations information" do
        f.input :curriculum_ids, as: :tags, :collection => Curriculum.where(program_id: semester_registration.student.program, year: semester_registration.student.year, semester: semester_registration.student.semester).all, display_name: :course_title, label: "Course Registration"
      end
    end
    f.inputs "Student registration information" do

      f.input :student_id, as: :search_select, url: admin_students_path,
          fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :academic_calendar_id, as: :search_select, url: admin_academic_calendars_path,
          fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :semester , :collection => [1, 2,3,4], :include_blank => false
      f.input :year, :collection => [1, 2,3,4,5,6,7], :include_blank => false
      f.input :mode_of_payment, as: :select, :collection => [ "Monthly Payment", "Every Two Month Payment", "Every Three Month Payment","Full Semester Payment"]
      # f.input :remark
      # if f.object.course_registrations.empty?
      #   f.object.course_registrations << CourseRegistration.new
      # end
      # panel "course registrations information" do
      #   f.input :curriculums, :as => :check_boxes, :collection => registration.student.program.curriculums.where(year: registration.student.year, semester: registration.student.semester).course_id
      # end
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        f.input :registrar_approval_status, as: :select, :collection => ["pending","approved", "deined"]
      end      
    end
    f.actions
  end

  show :title => proc{|student| student.student.name.full } do
    panel "Student registration information" do
      attributes_table_for semester_registration do
        row "full name", sortable: true do |n|
          link_to "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}" , admin_student_path(n.student.id) 
        end
        row "Student ID" do |si|
          si.student.student_id
        end
        row "Program" do |pr|
          link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
        end
        row "Department" do |si|
          si.student.department
        end
        row "Academic year" do |si|
          si.academic_calendar.calender_year
        end
        row :admission_type 
        row :study_level 
        row :year 
        row :semester
        row :remaining_amount
        row :mode_of_payment
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
    panel "Course Registration" do
      table_for semester_registration.course_registrations do
        column "Course title" do |pr|
          link_to pr.curriculum.course.course_title, admin_courses_path(pr.curriculum.course.id)
        end
        column "Course code" do |pr|
          pr.curriculum.course.course_code
        end
        column "Course module" do |pr|
          link_to pr.curriculum.course.course_module.module_code, admin_course_module_path(pr.curriculum.course.course_module.id) 
        end
        column "Credit hour" do |pr|
          pr.curriculum.credit_hour
        end
        column "Semester" do |se|
          se.curriculum.semester
        end
        column "Year" do |ye|
          ye.curriculum.year
        end
      end
    end
  end   
end

