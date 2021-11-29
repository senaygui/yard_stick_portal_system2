class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable, :trackable
  has_person_name

  ##validations
    # validates :username , :presence => true,:length => { :within => 2..50 }
    validates :first_name , :presence => true,:length => { :within => 2..50 }
    validates :last_name , :presence => true,:length => { :within => 1..50 }
    validates :role , :presence => true

  ## scope

    scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
    scope :total_users, lambda { order("created_at DESC")}
    scope :admins, lambda { where(:role => "admin") }
    scope :registrars, lambda { where(:role => "registrar") }
    scope :department_head, lambda { where(:role => "department head") }
    scope :dean, lambda { where(:role => "dean") }
end