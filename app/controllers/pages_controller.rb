class PagesController < ApplicationController
	# before_action :authenticate_student!
  def home
    authenticate_student!
  end
  def documents
    authenticate_student!
  end
  def update_document
    authenticate_student!
  end
  def digital_iteracy_quiz
  end
  def requirement
    
  end

  def profile
    authenticate_student!
  	@address = current_student.student_address
  	@emergency_contact = current_student.emergency_contact
  end

  def dashboard
    authenticate_student!
  	@address = current_student.student_address
  	@emergency_contact = current_student.emergency_contact
  end
end
