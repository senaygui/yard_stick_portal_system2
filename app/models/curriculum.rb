class Curriculum < ApplicationRecord
	before_save :course_title_assign
	##validations
    validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :full_course_price, :presence => true
	##associations
	  belongs_to :program
	  belongs_to :course
	  has_many :course_registrations, dependent: :destroy
  	has_many :semester_registrations, through: :course_registrations, dependent: :destroy
  private

  def course_title_assign
  	self[:course_title] = self.course.course_title
  end
end
