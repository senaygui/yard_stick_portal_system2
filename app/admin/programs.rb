ActiveAdmin.register Program do
  menu priority: 6
  permit_params :monthly_price,:full_semester_price,:two_monthly_price,:three_monthly_price,:program_semester,:department_id,:total_semester,:program_name,:program_code,:overview,:program_description,:created_by,:last_updated_by,:total_tuition,:study_level,:admission_type,:program_duration, curriculums_attributes: [:id,:course_id,:semester,:course_starting_date,:course_ending_date,:year,:credit_hour,:ects,:full_course_price,:course_title,:monthly_course_price,:created_by,:last_updated_by, :_destroy]

  index do
    selectable_column
    column :program_name
    column "Department", sortable: true do |d|
      link_to d.department.department_name, [:admin, d.department]
    end
    ## TODO: color label admission_type and study_level
    ## TODO: display number of currently admitted students in this program
    column "courses" do |c|
      c.curriculums.count
    end
    column :study_level
    column :admission_type
    column "duration",:program_duration
    number_column "Tuition",:total_tuition, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 
    # column "Created At", sortable: true do |c|
    #   c.created_at.strftime("%b %d, %Y")
    # end
    actions
  end

  filter :program_name
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :study_level, as: :select, :collection => ["undergraduate", "graduate"]
  filter :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"]
  filter :program_duration, as: :select, :collection => [1, 2,3,4,5,6,7]
  filter :program_semester
  # filter :total_semester     
  filter :created_by
  filter :last_updated_by
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
    f.inputs "porgram information" do
      f.input :program_name
      f.input :program_code
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :program_description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :department_id, as: :search_select, url: admin_departments_path,
          fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate", "TPVT"], :include_blank => false
      f.input :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"], :include_blank => false
      f.input :program_duration, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
      f.input :program_semester , :collection => [1, 2,3,4], :include_blank => false
      f.input :monthly_price
      f.input :full_semester_price
      f.input :two_monthly_price
      f.input :three_monthly_price
      # f.input :total_semester
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    if f.object.curriculums.empty?
      f.object.curriculums << Curriculum.new
    end
    panel "Curriculum" do
      f.has_many :curriculums,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          a.input :course_id, as: :search_select, url: admin_courses_path,
            fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
            order_by: 'id_asc'
          a.input :credit_hour, :required => true, min: 1, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
          a.input :year, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
          a.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
          a.input :course_starting_date, as: :date_time_picker 
          a.input :course_ending_date, as: :date_time_picker
          a.input :full_course_price
          a.input :monthly_course_price
          a.label :_destroy
          if a.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          end 
      end
    end
    f.actions
  end

  show title: :program_name do
    tabs do
      tab "Program information" do
        panel "Program information" do
          attributes_table_for program do
            row :program_name
            row :program_code
            row :overview
            row :program_description
            row "Department", sortable: true do |d|
              link_to d.department.department_name, [:admin, d.department] 
            end
            ## TODO: display number of currently admitted students in this program
            ## TODO: color label admission_type and study_level
            row :study_level
            row :admission_type
            row :program_duration
            row :program_semester
            # row :total_semester
            number_row "Tuition",:total_tuition, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      tab "Program curriculums" do
        (1..program.program_duration).map do |i|
          panel "ClassYear: Year #{i}" do
            (1..program.program_semester).map do |s|
              panel "Semester: #{s}" do
                table_for program.curriculums.where(year: i, semester: s).order('year ASC','semester ASC') do
                  ## TODO: wordwrap titles and long texts
                  column "module title" do |item|
                    link_to item.course.course_module.module_title, [ :admin, item.course.course_module ]
                  end
                  column "module code" do |item|
                    item.course.course_module.module_code
                  end
                  column "course title" do |item|
                    link_to item.course.course_title, [ :admin, item.course] 
                  end
                  column "course code" do |item|
                    item.course.course_code
                  end
                  column "credit hour" do |item|
                    item.credit_hour
                  end
                  column "ECTS" do |item|
                    item.ects
                  end
                  number_column "course price",:full_course_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 
                  column :created_by
                  column :last_updated_by
                  column "Starts at", sortable: true do |c|
                    c.course_starting_date.strftime("%b %d, %Y") if c.course_starting_date.present?
                  end
                  column "ends At", sortable: true do |c|
                    c.course_ending_date.strftime("%b %d, %Y") if c.course_ending_date.present?
                  end
                end
              end
            end      
          end 
        end
        
      end
    end
    
      
  end
end
