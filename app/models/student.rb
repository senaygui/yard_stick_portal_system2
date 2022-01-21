class Student < ApplicationRecord
  ##callbacks
  before_save :department_assignment
  before_save :student_id_generator
  after_save :student_semester_registration
  before_create :set_pwd

  
  # after_save :course_registration
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_person_name    
  ##associations
  belongs_to :program
  has_one :student_address, dependent: :destroy
  accepts_nested_attributes_for :student_address
  has_one :emergency_contact, dependent: :destroy
  accepts_nested_attributes_for :emergency_contact
  has_many :semester_registrations, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many_attached :documents, dependent: :destroy
  has_one_attached :photo, dependent: :destroy
  has_many :student_grades, dependent: :destroy
  has_many :grade_reports
  ##validations
  validates :first_name , :presence => true,:length => { :within => 2..100 }
  validates :middle_name , :presence => true,:length => { :within => 2..100 }
  validates :current_location , :presence => true,:length => { :within => 2..100 }
  validates :last_name , :presence => true,:length => { :within => 2..100 }
  validates :student_id , uniqueness: true
  validates	:gender, :presence => true
	validates	:date_of_birth , :presence => true
	validates	:study_level, :presence => true
  validates :admission_type, :presence => true,:length => { :within => 2..10 }
  # validates :photo, attached: true, content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg']
  # validates :documents, attached: true
  
  validate :password_complexity
  def password_complexity
    if password.present?
       if !password.match(/^(?=.*[a-z])(?=.*[A-Z])/) 
         errors.add :password, "must be between 5 to 20 characters which contain at least one lowercase letter, one uppercase letter, one numeric digit, and one special character"
       end
    end
  end
  ##scope
    scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
    scope :undergraduate, lambda { where(study_level: "undergraduate")}
    scope :graduate, lambda { where(study_level: "graduate")}
    scope :online, lambda { where(admission_type: "online")}
    scope :regular, lambda { where(admission_type: "regular")}
    scope :extention, lambda { where(admission_type: "extention")}
    scope :distance, lambda { where(admission_type: "distance")}
    scope :pending, lambda { where(document_verification_status: "pending")}
    scope :approved, lambda { where(document_verification_status: "approved")}
    scope :denied, lambda { where(document_verification_status: "denied")}
    scope :incomplete, lambda { where(document_verification_status: "incomplete")}

    # def with_student_address
    #   build_student_address if student_address.nil?
    # end
    
  # def approve_student
  #   self[:document_verification_status] = "approved"
  # end
  private
  ## callback methods
  def set_pwd
    self[:student_password] = self.password
  end
  def department_assignment
    self[:department] = program.department.department_name
  end
  def student_id_generator
    if self.document_verification_status == "approved" && !(self.student_id.present?)
      begin
        self.student_id = "#{self.program.program_code}/#{SecureRandom.random_number(1000..10000)}/#{Time.now.strftime("%y")}"
      end while Student.where(student_id: self.student_id).exists?
    end
  end

  def student_semester_registration
   if self.document_verification_status == "approved" && self.semester_registrations.last.nil? && self.year == 1
    SemesterRegistration.create do |registration|
      registration.student_id = self.id
      registration.created_by = self.created_by
      ## TODO: find the calender of student admission type and study level
      registration.academic_calendar_id = AcademicCalendar.last.id
      registration.year = self.year
      registration.semester = self.semester
      registration.program_name = self.program.program_name
      registration.admission_type = self.admission_type
      registration.study_level = self.study_level
      registration.registrar_approval_status ="approved"
      registration.finance_approval_status ="approved"
    end
   end 
   if self.document_verification_status == "approved" && self.year == 1 
    self.program.curriculums.where(year: self.year, semester: self.semester).each do |co|
      CourseRegistration.create do |course|
        course.semester_registration_id = self.semester_registrations.last.id
        course.curriculum_id = co.id
        course.course_title = co.course.course_title
        # course.course_title = co.course.course_title
      end
    end
   end
  end
  # def course_registration
  #  if self.student_registrations.last.present? && self.year == 1
  #   self.program.curriculums.where(year: self.year, semester: self.semester).each do |co|
  #     CourseRegistration.create do |course|
  #       course.student_registration_id = self.student_registrations.last.id
  #       course.curriculum_id = co.id
  #     end
  #   end
  #  end 
  # end

end
