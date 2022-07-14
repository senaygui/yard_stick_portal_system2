class StudentGrade < ApplicationRecord
  require "uri"
  require "net/http"
  
  after_save :generate_grade

  after_save :generate_grade_2013
  # after_save :update_grade_report

  belongs_to :course_registration, optional: true
  belongs_to :student
  belongs_to :course
  has_many :assessments, dependent: :destroy
	accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true


  def update_grade_report
    if self.course_registration.semester_registration.grade_report.present?
      if self.student.grade_reports.count == 1 
        total_credit_hour = self.course_registration.semester_registration.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.curriculum.credit_hour) : 0 }.sum

        total_grade_point = self.course_registration.semester_registration.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.student_grade.grade_in_number.to_f) : 0 }.sum

        sgpa = total_credit_hour == 0 ? 0 : (total_grade_point / total_credit_hour).round(1)
        cumulative_total_credit_hour = total_credit_hour
        cumulative_total_grade_point = total_grade_point
        cgpa = cumulative_total_credit_hour == 0 ? 0 : (cumulative_total_grade_point / cumulative_total_credit_hour).round(1)
        

        self.course_registration.semester_registration.grade_report.update(semester_credit_hr_total: total_credit_hour, semester_total_grade_point: total_grade_point, sgpa: sgpa, cumulative_total_credit_hour: cumulative_total_credit_hour, cumulative_total_grade_point: cumulative_total_grade_point, cgpa: cgpa)

        if (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("I").present?) || (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("NG").present?)
          academic_status = "Incomplete"
        else
          academic_status = AcademicStatus.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
        end

        if self.course_registration.semester_registration.grade_report.academic_status != academic_status
          # if ((self.course_registration.semester_registration.grade_report.academic_status == "Dismissal") || (self.course_registration.semester_registration.grade_report.academic_status == "Incomplete")) && ((academic_status != "Dismissal") || (academic_status != "Incomplete"))
          #   if self.program.program_semester > self.student.semester
          #     promoted_semester = self.student.semester + 1
          #     self.student.update_columns(semester: promoted_semester)
          #   elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
          #     promoted_year = self.student.year + 1
          #     self.student.update_columns(semester: 1)
          #     self.student.update_columns(year: promoted_year)
          #   end
          # end
          self.course_registration.semester_registration.grade_report.update_columns(academic_status: academic_status)
        end
      else
        total_credit_hour = self.course_registration.semester_registration.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.curriculum.credit_hour) : 0 }.sum

        total_grade_point = self.course_registration.semester_registration.course_registrations.collect { |oi| ((oi.student_grade.grade_in_letter != "I") && (oi.student_grade.grade_in_letter != "NG")) ? (oi.student_grade.grade_in_number.to_f) : 0 }.sum

        sgpa = total_credit_hour == 0 ? 0 : (total_grade_point / total_credit_hour).round(1)
  
        cumulative_total_credit_hour = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_credit_hour + total_credit_hour
        cumulative_total_grade_point = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_grade_point + total_grade_point
        cgpa = (cumulative_total_grade_point / cumulative_total_credit_hour).round(1)
        
        academic_status = AcademicStatus.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
        
        self.course_registration.semester_registration.grade_report.update(semester_credit_hr_total: total_credit_hour, semester_total_grade_point: total_grade_point, sgpa: sgpa, cumulative_total_credit_hour: cumulative_total_credit_hour, cumulative_total_grade_point: cumulative_total_grade_point, cgpa: cgpa)
        
        if (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("I").present?) || (self.course_registration.semester_registration.course_registrations.joins(:student_grade).pluck(:grade_in_letter).include?("NG").present?)
          academic_status = "Incomplete"
        else
          academic_status = AcademicStatus.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
        end

        if self.course_registration.semester_registration.grade_report.academic_status != academic_status
          # if ((self.course_registration.semester_registration.grade_report.academic_status == "Dismissal") || (self.course_registration.semester_registration.grade_report.academic_status == "Incomplete")) && ((academic_status != "Dismissal") || (academic_status != "Incomplete"))
          #   if self.program.program_semester > self.student.semester
          #     promoted_semester = self.student.semester + 1
          #     self.student.update_columns(semester: promoted_semester)
          #   elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
          #     promoted_year = self.student.year + 1
          #     self.student.update_columns(semester: 1)
          #     self.student.update_columns(year: promoted_year)
          #   end
          # end
          self.course_registration.semester_registration.grade_report.update_columns(academic_status: academic_status)
        end

      end
    end
  end

	# def grade_letter_value
 #    assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum
 #  end
  # def generate_grade
  #   if assessments.present?
  #     if assessments.where(result: nil).empty?
  #       if assessments.where("result > ?", 0).count == 3
  #         grade_in_letter = Grade.where("min_value <= ?", self.grade_letter_value.truncate).where("max_value >= ?", self.grade_letter_value.truncate).last.grade
  #         grade_in_number = Grade.where("min_value <= ?", self.grade_letter_value.truncate).where("max_value >= ?", self.grade_letter_value.truncate).last.grade_value * self.curriculum.credit_hour
  #       	self.update_columns(grade_in_number: grade_in_number)
  #         self.update_columns(grade_letter_value: grade_letter_value)
  #       elsif assessments.where.(assessment: "Final (40%)").where(result: nil).present?
  #         grade_in_letter = "NG"
  #         grade_in_number = 0
  #         self.update_columns(grade_in_letter: grade_in_letter)
  #         self.update_columns(grade_in_number: grade_in_number)
  #       elsif assessments.where(assessment: "Assignment 02 (30%)",result: nil).or(assessments.where(assessment: "Assignment 01 (30%)",result: 0)).present?
  #         grade_in_letter = "I"
  #         grade_in_number = 0
  #         self.update_columns(grade_in_letter: grade_in_letter)
  #         self.update_columns(grade_in_number: grade_in_number)
  #       end
  #     elsif assessments.where(result: nil)
  #       self.update_columns(grade_in_letter: "I")
  #       # needs to be empty and after a week changes to f
  #       self.update_columns(grade_letter_value: 0)
  #     end
  #   elsif self.grade_letter_value.present?
  #     s = self.grade_letter_value.to_f.truncate
  #     grade_in_letter = Grade.where("min_value <= ?", s).where("max_value >= ?", s).last.grade
  #     grade_in_number = Grade.where("min_value <= ?", s).where("max_value >= ?", s).last.grade_value * self.course_registration.curriculum.credit_hour
  #     self.update_columns(grade_in_letter: grade_in_letter)
  #     self.update_columns(grade_in_number: grade_in_number)
  #   else
  #     grade_in_letter = "I"
  #     grade_in_number = 0
  #     self.update_columns(grade_in_letter: grade_in_letter)
  #     self.update_columns(grade_in_number: grade_in_number)
  #   end
    
  # 	# self[:grade_in_letter] = grade_in_letter
  # end

  def generate_grade_2013
    s = self.grade_letter_value.to_f.truncate
      grade_in_letter = Grade.where("min_value <= ?", s).where("max_value >= ?", s).last.grade
      grade_in_number = Grade.where("min_value <= ?", s).where("max_value >= ?", s).last.grade_value * self.course_registration.curriculum.credit_hour
      self.update_columns(grade_in_letter: grade_in_letter)
      self.update_columns(grade_in_number: grade_in_number)
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
    # self.update_columns(grade_in_letter: grade_letter)
    self.update(grade_letter_value: total_grade.to_f)
  end
  # before_save :update_subtotal
	private

  # def update_subtotal
  #   self[:grade_letter_value] = grade_letter_value
  # end
end
