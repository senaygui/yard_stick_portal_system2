ActiveAdmin.register Course do
  menu priority: 5
  
permit_params :course_module_id,:course_title,:course_code,:course_description,:created_by,:last_updated_by

  index do
    selectable_column
    column :course_title
    column "module_title", sortable: true do |m|
     link_to m.course_module.module_title, [:admin, m.course_module]
    end
    column :course_code
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :course_title
  filter :course_code 
  filter :course_module_id, as: :search_select_filter, url: proc { admin_course_modules_path },
         fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
         order_by: 'module_code_asc' 
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  
  form do |f|
    f.semantic_errors
    f.inputs "Course information" do
      f.input :course_title
      f.input :course_code
      f.input :course_description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :course_module_id, as: :search_select, url: admin_course_modules_path,
          fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
          order_by: 'id_asc'
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    f.actions
  end

  show title: :course_title do
    panel "Course information" do
      attributes_table_for course do
        row :course_title
        row :course_code
        row "module title", sortable: true do |d|
          link_to d.course_module.module_title, admin_course_module_path(d.course_module.id)
        end
        row :course_description
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end 
  sidebar "program belongs to", :only => :show do
    table_for course.curriculums do

      column "program" do |c|
        link_to c.program.program_name, admin_program_path(c.program.id)
      end
    end
  end 
end
