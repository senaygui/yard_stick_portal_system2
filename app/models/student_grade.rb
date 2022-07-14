class StudentGrade < ApplicationRecord
  require "uri"
  require "net/http"
  
  after_save :generate_grade

  belongs_to :course_registration, optional: true
  belongs_to :student
  belongs_to :course
  has_many :assessments, dependent: :destroy
	accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true

	def grade_in_number
    assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum
  end
  def generate_grade
    if assessments.where(result: nil).empty?
      if assessments.where("result > ?", 0).count == 3
        grade_in_letter = Grade.where("min_value <= ?", self.grade_in_number.truncate).where("max_value >= ?", self.grade_in_number.truncate).last.grade
        grade_letter_value = Grade.where("min_value <= ?", self.grade_in_number.truncate).where("max_value >= ?", self.grade_in_number.truncate).last.grade_value
      	self.update_columns(grade_in_letter: grade_in_letter)
        self.update_columns(grade_letter_value: grade_letter_value)
      elsif assessments.where(assessment: "Final (40%)").where(result: 0).present?
        grade_in_letter = "NG"
        grade_letter_value = 0
        self.update_columns(grade_in_letter: grade_in_letter)
        self.update_columns(grade_letter_value: grade_letter_value)
      elsif assessments.where(assessment: "Assignment 02 (30%)",result: 0).or(assessments.where(assessment: "Assignment 01 (30%)",result: 0)).present?
        grade_in_letter = "I"
        grade_letter_value = 0
        self.update_columns(grade_in_letter: grade_in_letter)
        self.update_columns(grade_letter_value: grade_letter_value)
      end
    elsif assessments.where(result: nil)
      self.update_columns(grade_in_letter: "I")
      # needs to be empty and after a week changes to f
      self.update_columns(grade_letter_value: 0)
    end
    
  	# self[:grade_in_letter] = grade_in_letter
  end

  # def generate_grade
  #   if assessments.where(result: nil).empty?
  #     grade_in_letter = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total).where("max_row_mark >= ?", self.assesment_total).last.letter_grade
  #     grade_letter_value = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total).where("max_row_mark >= ?", self.assesment_total).last.grade_point
  #     self.update_columns(letter_grade: grade_in_letter)
  #     self.update_columns(grade_point: grade_letter_value)
  #   elsif assessments.where(result: nil)
  #     self.update_columns(letter_grade: "I")
  #     # needs to be empty and after a week changes to f
  #     self.update_columns(grade_point: 0)
  #   end
  #   # self[:grade_in_letter] = grade_in_letter
  # end

  def moodle_grade
    url = URI("https://lms.yic.edu.et/webservice/rest/server.php")
    moodle = MoodleRb.new('9233bd19465dce9510838176b7b1aa76', 'https://lms.yic.edu.et/webservice/rest/server.php')
    lms_student = moodle.users.search(email: "#{self.student.email}")
    user = lms_student[0]["id"]
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    form_data = [['wstoken', '9233bd19465dce9510838176b7b1aa76'],['wsfunction', 'gradereport_overview_get_course_grades'],['moodlewsrestformat', 'json'],['userid', "#{user}"]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)
    # puts response.read_body
    results =  JSON.parse(response.read_body)
    course_code = moodle.courses.search("#{self.course_registration.curriculum.course.course_code}")
    course = course_code["courses"][0]["id"]
    
    total_grade = results["grades"].map {|h1| h1['rawgrade'] if h1['courseid']== course}.compact.first
    grade_letter = results["grades"].map {|h1| h1['grade'] if h1['courseid']== course}.compact.first
    self.update_columns(grade_in_letter: grade_letter)
    self.update_columns(grade_letter_value: total_grade)
  end
  before_save :update_subtotal
	private

  def update_subtotal
    self[:grade_in_number] = grade_in_number
  end
end
