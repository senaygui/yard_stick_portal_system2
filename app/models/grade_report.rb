class GradeReport < ApplicationRecord
  belongs_to :semester_registration
  belongs_to :student
  belongs_to :academic_calendar
end
