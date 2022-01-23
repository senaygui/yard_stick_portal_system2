ActiveAdmin.register Student do
    active_admin_import :validate => false,
                            :before_batch_import => proc { |import|
                              import.csv_lines.length.times do |i|
                                import.csv_lines[i][3] = Student.new(:password => import.csv_lines[i][3]).encrypted_password
                              end
                            },
                            # :template_object => ActiveAdminImport::Model.new(
                            #     :hint => "file will be imported with such header format: 'email', 'first_name','last_name','encrypted_password','middle_name','gender','student_id','date_of_birth','program_id','department','admission_type','study_level','marital_status','year','semester','account_verification_status','document_verification_status','account_status','graduation_status','student_password'"
                            # ),
                            :timestamps=> true,
                            :batch_size => 1000
  scoped_collection_action :scoped_collection_update, form: -> do
                                         { 
                                          account_status: 'text'
                                          }
                                        end

  batch_action :flag, form: {
    semester: :text
  } do |ids, inputs|
    # inputs is a hash of all the form fields you requested
    redirect_to collection_path, notice: [ids, inputs].to_s
  end
  menu priority: 7
  permit_params :current_location,:current_occupation,:tempo_status,:created_by,:last_updated_by,:photo,:email,:password,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: []
  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
  # csv do
  #   column :student_id
  #   column :student_password
  #   column :first_name
  #   column :last_name
  #   column :middle_name
  #   column :gender
  #   column :date_of_birth
  #   column :marital_status
  #   column :email
  #   column :year
  #   column :semester
  #   column :study_level
  #   column :admission_type
  #   column :program_id
  #   column :created_at
  #   column "country" do |pass|
  #     pass.student_address.country
  #   end
  #   column "city" do |pass|
  #     pass.student_address.city
  #   end
  #   column "sub_city" do |pass|
  #     pass.student_address.sub_city
  #   end
  #   column "region" do |pass|
  #     pass.student_address.region
  #   end
  #   column "zone" do |pass|
  #     pass.student_address.zone
  #   end
  #   column "woreda" do |pass|
  #     pass.student_address.woreda
  #   end
  #   column "house number" do |pass|
  #     pass.student_address.house_number
  #   end
  #   column "cell phone" do |pass|
  #     pass.student_address.cell_phone
  #   end
  #   column "house phone" do |pass|
  #     pass.student_address.house_phone
  #   end
  #   column "pobox" do |pass|
  #     pass.student_address.pobox
  #   end
  #   column "full_name" do |pass|
  #     pass.emergency_contact.full_name
  #   end
  #   column "relationship" do |pass|
  #     pass.emergency_contact.relationship
  #   end
  #   column "cell_phone" do |pass|
  #     pass.emergency_contact.cell_phone
  #   end
  #   column "current_occupation" do |pass|
  #     pass.emergency_contact.current_occupation
  #   end
  #   column "name_of_current_employer" do |pass|
  #     pass.emergency_contact.name_of_current_employer
  #   end
  #   column "email_of_employer" do |pass|
  #     pass.emergency_contact.email_of_employer
  #   end
  #   column "office_phone_number" do |pass|
  #     pass.emergency_contact.office_phone_number
  #   end
  #   column "pobox" do |pass|
  #     pass.emergency_contact.pobox
  #   end

  # end
  index do
    selectable_column
    column :student_id
    column "full name", sortable: true do |n|
      n.name.full.upcase
    end
    column "Department", sortable: true do |d|
      link_to d.program.department.department_name, [:admin, d.program.department]
    end
    column "program", sortable: true do |d|
      link_to d.program.program_name, [:admin, d.program]
    end
    column :study_level
    column :admission_type
    # column :year
    column "document verification" do |s|
      status_tag s.document_verification_status
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, label: "Student ID"
  filter :first_name
  filter :last_name
  filter :middle_name
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :study_level, as: :select, :collection => ["undergraduate", "graduate"]
  filter :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"]
  filter :department   
  filter :year
  filter :current_occupation
  filter :current_location

  filter :account_verification_status, as: :select, :collection => ["pending","approved", "denied", "incomplete"]
  filter :document_verification_status, as: :select, :collection => ["pending","approved", "denied", "incomplete"]
  filter :account_status, as: :select, :collection => ["active","suspended"]
  filter :graduation_status      
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  #TODO: color label scopes
  scope :recently_added
  scope :pending
  scope :approved
  scope :denied
  scope :incomplete
  scope :undergraduate
  scope :graduate

  scope :online, :if => proc { current_admin_user.role == "admin" }
  scope :regular, :if => proc { current_admin_user.role == "admin" }
  scope :extention, :if => proc { current_admin_user.role == "admin" }
  scope :distance, :if => proc { current_admin_user.role == "admin" }

  

  form do |f|
    f.semantic_errors
    f.semantic_errors *f.object.errors.keys
    # if f.object.new_record?
      f.inputs "Student basic information" do
        div class: "avatar-upload" do
          div class: "avatar-edit" do
            f.input :photo, as: :file, label: "Upload Photo"
          end
          div class: "avatar-preview" do
            if f.object.photo.attached? 
              image_tag(f.object.photo,resize: '100x100',class: "profile-user-img img-responsive img-circle", id: "imagePreview")
            else
              image_tag("blank-profile-picture-973460_640.png",class: "profile-user-img img-responsive img-circle", id: "imagePreview")
            end
          end
        end
        f.input :first_name
        f.input :last_name
        f.input :middle_name
        f.input :gender, as: :select, :collection => ["Male", "Female"], :include_blank => false
        f.input :date_of_birth, as: :date_time_picker
        f.input :marital_status, as: :select, :collection => ["Single", "Married", "Widowed","Separated","Divorced"], :include_blank => false
        f.input :email
        f.input :password
        f.input :password_confirmation
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          f.input :year, as: :hidden, :input_html => { :value => 1}
          f.input :semester, as: :hidden, :input_html => { :value => 1}
        else
          f.input :current_password
          f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
        end   
        f.input :current_occupation 
        f.input :current_location   
      end
      f.inputs "Student admission information" do
        f.input :study_level, as: :select, :collection => ["undergraduate", "graduate", "TPVT"], :include_blank => false
        f.input :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"], :include_blank => false
        f.input :program_id, as: :search_select, url: admin_programs_path,
            fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
            order_by: 'id_asc'
      end
      f.inputs "Student address information", :for => [:student_address, f.object.student_address || StudentAddress.new ] do |a|
        a.input :country, as: :country, selected: 'ET', priority_countries: ["ET", "US"], include_blank: "select country"
        #TODO: add select list to city,sub_city,state,region,zone
        a.input :city
        a.input :sub_city
        a.input :region
        a.input :zone
        a.input :woreda
        a.input :house_number
        a.input :cell_phone
        a.input :house_phone
        a.input :pobox
      end
      f.inputs "Student emergency contact person information", :for => [:emergency_contact, f.object.emergency_contact || EmergencyContact.new ] do |a|
        a.input :full_name
        a.input :relationship, as: :select, :collection => ["Husband", "Wife", "Father", "Mother", "Legal guardian","Son","Daughter","Brother","Sister", "Friend","Uncle","Aunt","Cousin","Nephew","Niece","Grandparent"], :include_blank => false
        a.input :cell_phone
        a.input :email
        a.input :current_occupation
        a.input :name_of_current_employer, hint: "current employer company name or person name of the student emergency contact person"
        a.input :email_of_employer, hint: "current employer company email or person email of the student emergency contact person"
        a.input :office_phone_number, hint: "current employer company phone number or person phone number of the student emergency contact person"
        a.input :pobox
      end
      f.inputs 'Dcouemnts', multipart: true do
        div class: "file-upload" do
          f.drag_and_drop_file_field :documents do
            'Drag and drop or click here to upload all the necessary documents!'
          end
          
        end
        # if f.object.documents.attached?
        #   div class: "document-preview container" do
        #     f.object.documents.each do |document|
        #       if document.variable?
        #           div class: "preview-card" do
        #             span image_tag(document, size: '200x200')
        #             span link_to 'delete', delete_document_admin_student_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
        #           end
        #       elsif document.previewable?
        #           div class: "preview-card" do
        #             span image_tag(document.preview(resize: '200x200'))
        #             span link_to 'delete', delete_document_admin_student_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
        #           end
        #       end
        #     end
        #   end
        # end
      end
      f.inputs "temporary document status" do
        f.input :tempo_status
      end
    # end
    f.inputs "Student account and document verification" do
      f.input :account_verification_status, as: :select, :collection => ["pending","approved", "denied", "incomplete"], :include_blank => false
      f.input :document_verification_status, as: :select, :collection => ["pending","approved", "denied", "incomplete"], :include_blank => false         
    end
    if !f.object.new_record?
      f.inputs "Student account status" do
        f.input :account_status, as: :select, :collection => ["active","suspended"]
      end
    end
    f.actions
  end
  # member_action :delete_document, method: :delete do
  #   @pic = ActiveStorage::Attachment.find(params[:id])
  #   @pic.purge_later
  #   redirect_back(fallback_location: edit_admin_student_path)
  # end
  #TODO: make delete btn in show not primery color
  #TODO: add account approval status action modal

  # member_action :student_approval, method: :put do
  #   @student= Student.find(params[:id])
  #   @student.approve_student
  #   redirect_back(fallback_location: admin_student_path)
  # end
  action_item :edit, only: :show do
    link_to 'Approve Student', edit_admin_student_path(student.id)
  end
  show :title => proc{|student| truncate(student.name.full, length: 50) } do
    tabs do
      tab "student General information" do
        panel "Student Main information" do
          attributes_table_for student do
            row "photo" do |pt|
              if pt.photo.attached? 
                span image_tag(pt.photo, size: '150x150', class: "img-corner")
              else
                span image_tag("blank-profile-picture-973460_640.png", size: '150x150', class: "img-corner")
              end
            end
            row "full name", sortable: true do |n|
              n.name.full.upcase
            end
            row "Student ID" do |si|
              si.student_id
            end
            row "Program" do |pr|
              link_to pr.program.program_name, admin_program_path(pr.program.id)
            end
            row :current_occupation
            row :department
            row :admission_type
            row :study_level
            row :year
            # row :semester
            row :account_verification_status do |s|
              status_tag s.account_verification_status
            end
            row "admission Date" do |d|
              d.created_at.strftime("%b %d, %Y")
            end
            row :tempo_status
            #row :graduation_status
          end
        end
        panel "Basic information" do
          attributes_table_for student do
            row :email
            row :gender
            row :date_of_birth, sortable: true do |c|
              c.date_of_birth.strftime("%b %d, %Y")
            end
            row :marital_status
          end
        end  
      end
      tab "Account status information" do
        panel "Account status information" do
          attributes_table_for student do
            row :account_verification_status do |s|
              status_tag s.account_verification_status
            end
            row :document_verification_status do |s|
              status_tag s.document_verification_status
            end
            row :account_status do |s|
              status_tag s.account_status
            end
            row  :sign_in_count, default: 0, null: false
            row :current_sign_in_at
            row :last_sign_in_at
            row :current_sign_in_ip
            row :last_sign_in_ip
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      tab "Student Document" do
        panel "Document" do
          attributes_table_for student do
            row "Documents" do |i|
              div class: "document-preview container" do
                i.documents.each do |doc| 
                  if doc.variable?
                    div class: "preview-card" do
                      span link_to image_tag(doc, size: '200x200'), doc
                    end
                  elsif doc.previewable?
                    div class: "preview-card" do
                      span link_to image_tag(doc.preview(resize: '200x200')), doc
                    end
                  end
                end
              end
            end
          end
        end
      end
      tab "Student Address" do
        panel "Student Address" do
          attributes_table_for student.student_address do
            row :country
            row :city
            row :region
            row :zone
            row :sub_city
            row :house_number
            row :cell_phone
            row :house_phone
            row :pobox
            row :woreda
          end
        end
        panel "Student Emergency Contact information" do
          attributes_table_for student.emergency_contact do
            row :full_name
            row :relationship
            row :cell_phone
            row :email
            row :current_occupation
            row :name_of_current_employer
            row :email_of_employer
            row :office_phone_number
            row :pobox
          end
        end
      end
      tab "Grade Report" do
      end
      
    end
  end
  sidebar "Account Status", :only => :index do
    panel "scope" do
      
    end

  end
end
