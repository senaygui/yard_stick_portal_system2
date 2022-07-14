ActiveAdmin.register AcademicStatus do
  permit_params :status,:min_value,:max_value,:created_by, :updated_by

  index do
    selectable_column
    column :status
    column :min_value
    column :max_value
    column :created_by
    column :updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
  form do |f|
    columns do
      column do
        panel "Academic status informations" do
          f.semantic_errors
          f.inputs do
            f.input :status
            f.input :min_value
            f.input :max_value
            if f.object.new_record?
              f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            else
              f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
            end  
          end
        end
      end
    end
    f.actions
  end
end
