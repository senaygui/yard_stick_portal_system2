class StudentGrade < ApplicationRecord
  belongs_to :course_registration
  belongs_to :student
  belongs_to :course
  has_many :assessments, dependent: :destroy
	accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true

	def grade_in_number
    assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum
  end
  def generate_grade
    if assessments.where(result: nil).empty?
      grade_in_letter = Grade.where("min_value <= ?", self.grade_in_number).where("max_value >= ?", self.grade_in_number).last.grade
      grade_letter_value = Grade.where("min_value <= ?", self.grade_in_number).where("max_value >= ?", self.grade_in_number).last.grade_value
      	self.update_columns(grade_in_letter: grade_in_letter)
        self.update_columns(grade_letter_value: grade_letter_value)
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

  before_save :update_subtotal
	private

  def update_subtotal
    self[:grade_in_number] = grade_in_number
  end
end
