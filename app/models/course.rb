class Course < ApplicationRecord
	#validations
    validates :course_title, :presence => true,:length => { :within => 2..140 }
    validates :course_code, :presence => true,:length => { :within => 2..25 }
  ##associations
  	belongs_to :course_module
  	has_many :curriculums, dependent: :destroy
 		has_many :programs, through: :curriculums, dependent: :destroy
 		has_many :student_grades, dependent: :destroy
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
end
