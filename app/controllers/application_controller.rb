class ApplicationController < ActionController::Base
    add_flash_types :info, :error, :warning
  def home
    render html: "welcome to yic online"
  end
  def access_denied(exception)
    flash[:error] = exception.message
    
    redirect_to admin_root_path 
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  def current_ability
    if current_admin_user.kind_of?(AdminUser)
      @current_ability ||= Ability.new(current_admin_user)
    else
      @current_ability ||= UserAbility.new(current_user)
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |student_params|
      student_params.permit(:grade_8_ministry,:grade_10_matric,:grade_12_matric,:coc,:highschool_transcript,:diploma_certificate,:degree_certificate,:temporary_degree_certificate,:student_copy,:offical,:current_location,:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
    end
    devise_parameter_sanitizer.permit(:account_update) do |student_params|
      # student_params.permit(:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
    end
    devise_parameter_sanitizer.permit(:sign_in) do |student_params|
      student_params.permit(:email, :password)
    end
  end
end
