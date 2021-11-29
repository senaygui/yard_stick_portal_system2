ActiveAdmin.register AdminUser do
  menu priority: 2
  permit_params :email, :password, :password_confirmation,:first_name,:last_name,:middle_name,:role,:username
  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
  index do
    selectable_column
    id_column
    column "full name", sortable: true do |n|
      n.name.full 
    end
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :middle_name
  filter :role
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  scope :recently_added
  scope :total_users
  scope :admins
  scope :registrars
  scope :department_head
  scope :dean

  form do |f|
    f.inputs "Adminstration Account" do
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      if !f.object.new_record?
        f.input :current_password
      end
      f.input :role,  :as => :select, :collection => [["Admin","admin"],["Registrar","registrar"], ["Distance Registrar","distance_registrar"], ["Online Registrar","online_registrar"], ["Regular Registrar","regular_registrar"], ["Extention Registrar","extention_registrar"], ["Finance","finance"], ["Distance Finance","distance_finance"], ["Online Finance","online_finance"], ["Regular Finance","regular_finance"], ["Extention Finance","extention_finance"], ["Department head", "department head"],["Dean","dean"], ["teacher", "teacher"]], label: "Account Role", :include_blank => false
    end
    f.actions
  end

end
