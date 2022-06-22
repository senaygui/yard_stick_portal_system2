ActiveAdmin.register GradeReport do

permit_params :semester_registration_id,:student_id,:academic_calendar_id,:cgpa,:sgpa,:semester,:year,:academic_status,:created_at,:updated_at,:previous_credit_hr_total,:semester_credit_hr_total,:previous_grade_point_total,:previous_ang_total,:previous_alg_total,:semester_total_grade_point,:cumulative_total_credit_hour,:cumulative_total_grade_point

  index do
    selectable_column
    column "Student Name", sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column "Student ID", sortable: true do |n|
      n.student.student_id
    end
    column :program, sortable: true do |pro|
      pro.student.program.program_name
    end
    column :department, sortable: true do |pro|
      pro.student.department_name
    end
    # column :admission_type
    # column :study_level
    column :academic_status
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column "Year, Semester", sortable: true do |n|
      "Year #{n.year}, Semester #{n.semester}"
    end
    column "SGPA",:sgpa
    column "CGPA",:cgpa
    column "Issue Date", sortable: true do |c|
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
  filter :year
  filter :semester
  filter :cumulative_total_credit_hour
  filter :cumulative_total_grade_point
  filter :cgpa
  filter :sgpa
  filter :academic_status
  filter :created_at
  filter :updated_at

  # filter :admission_type
  # filter :study_level   
  # filter :min_cgpa_value_to_pass
  # filter :created_at
  # filter :updated_at


  show title: "Grade Report" do
    columns do
      column max_width: "30%" do
        panel "Grade Report Information" do
          attributes_table_for grade_report do
            row "Student Name" do |n|
              link_to "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}", admin_student_path(n.student)
            end
            row "Student ID" do |n|
              n.student.student_id
            end
            row :program do |pro|
              pro.student.program.program_name
            end
            row :department do |pro|
              pro.student.department_name
            end
            row "Academic Year" do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row "Year, Semester" do |n|
              "Year #{n.year}, Semester #{n.semester}"
            end
            row :academic_status
            row "Issue Date", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
            row "updated At", sortable: true do |c|
              c.updated_at.strftime("%b %d, %Y")
            end
          end
        end
      end
      column min_width: "67%" do
        panel "Course Registration" do
          table_for grade_report.semester_registration.course_registrations do
            column "Course title" do |pr|
              link_to pr.course_title, admin_course_path(pr.course)
            end
            column "Course code" do |pr|
              pr.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course.course_module.module_code, admin_course_module_path(pr.course.course_module.id) 
            end
            column "Credit hour" do |pr|
              pr.course.credit_hour
            end
            column "Letter Grade" do |pr|
              pr.student_grade.grade_in_letter
            end
            column "Grade Point" do |pr|
              pr.student_grade.grade_letter_value
            end
          end
        end
        panel "report" do
          table(class: 'form-table') do
            tr do
              th '  ', class: 'form-table__col'
              th 'Cr Hrs', class: 'form-table__col'
              th 'Grade Point', class: 'form-table__col'
              th 'Average (GPA)', class: 'form-table__col'
            end
            tr class: "form-table__row" do
              th 'Current Semester Total', class: 'form-table__col'
              td "#{grade_report.semester_credit_hr_total}", class: 'form-table__col'
              td "#{grade_report.semester_total_grade_point}", class: 'form-table__col'
              td "#{grade_report.sgpa}", class: 'form-table__col'
            end
            tr class: "form-table__row" do
              th 'Previous Total', class: 'form-table__col'
              if grade_report.student.grade_reports.count > 1
                td "#{grade_report.previous_credit_hr_total}", class: 'form-table__col'
                td "#{grade_report.previous_grade_point_total}", class: 'form-table__col'
                td "#{grade_report.previous_ang_total}", class: 'form-table__col'
              end
            end
            tr class: "form-table__row" do
              th 'Cumulative', class: 'form-table__col'
              td "#{grade_report.cumulative_total_credit_hour}", class: 'form-table__col'
              td "#{grade_report.cumulative_total_grade_point}", class: 'form-table__col'
              td "#{grade_report.cgpa}", class: 'form-table__col'
            end
          end
        end
      end
    end  
  end 
  
end
