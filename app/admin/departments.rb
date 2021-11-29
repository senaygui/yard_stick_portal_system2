ActiveAdmin.register Department do
  menu priority: 4
  permit_params :department_name,:background,:facility,:overview,:location,:phone_number,:email,:facebook_handle,:telegram_handle,:twitter_handle,:instagram_handle,:created_by,:last_updated_by, :alternative_phone_number, :college_id

  index do
    selectable_column
    column :department_name
    column "Programs", sortable: true do |c|
      c.programs.count
    end
    column :overview, sortable: true do |o|
      truncate o.overview, length: 140
    end
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :department_name
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.input :college_id, as: :hidden, :input_html => { :value => 1}
    f.inputs "Department basic information" do
      f.input :department_name
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :background,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :facility,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
    end

    f.inputs "Department address" do
      f.input :location 
      #TODO: add phone number mask
      f.input :phone_number
      f.input :alternative_phone_number
      f.input :email
    end

    f.inputs "Social media address" do
      f.input :facebook_handle
      f.input :telegram_handle
      f.input :twitter_handle
      f.input :instagram_handle
    end
    if f.object.new_record?
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    else
      f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    end 
    f.actions
  end

  show title: :department_name do
    panel "Department basic information" do
      attributes_table_for department do
        row :department_name
        row "college" do |c|
          link_to c.college.college_name, [:admin, c.college]
        end
        row :overview
        row :background
        row :facility
        row "Programs", sortable: true do |c|
          department.programs.count
        end
        row :location
        row :phone_number
        row :alternative_phone_number
        row :email 
        row :facebook_handle
        row :twitter_handle
        row :instagram_handle 
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end
  
  sidebar "Programs", :only => :show do
    table_for department.programs do

      column "Program name" do |program|
        link_to program.program_name, admin_program_path(program.id)
      end
    end
  end
  sidebar "modules", :only => :show do
    table_for department.course_modules do

      column "Course Modules" do |course_module|
        link_to course_module.module_title, admin_course_module_path(course_module.id)
      end
    end
  end
  
end
