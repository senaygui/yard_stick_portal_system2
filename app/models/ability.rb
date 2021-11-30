
# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new

    case user.role
    when "admin"
        can :manage, StudentGrade
        can :manage, GradeReport
        can :manage, GradeRule
        can :manage, Grade
        can :manage, AdminUser
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Program
        can :manage, College
        #TODO: after one college created disable new action   
        cannot :destroy, College, id: 1

        can :manage, Department
        can :manage, CourseModule
        can :manage, Course
        can :manage, Student
        can :manage, PaymentMethod
        can :manage, AcademicCalendar
        can :manage, CollegePayment
        can :manage, SemesterRegistration
        can :manage, Invoice
    when "teacher"
        can :read, Student
        can :read, SemesterRegistration
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, StudentGrade
        can :manage, GradeReport
        can :manage, GradeRule
        can :manage, Grade
    when "finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student
        can :manage, PaymentMethod
        can :read, AcademicCalendar
        can :manage, CollegePayment
        can :read, SemesterRegistration
        can :manage, Invoice
    when "registrar"
        can :manage, StudentGrade
        can :manage, GradeReport
        can :manage, GradeRule
        can :manage, Grade
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1
        can :manage, AcademicCalendar
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, Student
        # can :read, PaymentMethod
        can :manage, AcademicCalendar
        # can :manage, CollegePayment
        can :manage, SemesterRegistration
        can :read, Invoice
    when "distance_registrar"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "distance"
        can :read, Program, admission_type: "distance"
        can :read, AcademicCalendar, admission_type: "distance"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "distance"
        can :read, Invoice
    when "online_registrar"
        can :read, StudentGrade
        can :read, GradeReport
        can :read, GradeRule
        can :read, Grade
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "online"
        can :read, Program, admission_type: "online"
        can :read, AcademicCalendar, admission_type: "online"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "online"
        can :read, Invoice
    when "regular_registrar"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, AcademicCalendar, admission_type: "regular"
        can :manage, Student, admission_type: "regular"
        can :read, Program, admission_type: "regular"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "regular"
        can :read, Invoice 
    when "extention_registrar"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "extention"
        can :read, AcademicCalendar, admission_type: "extention"
        can :read, Program, admission_type: "extention"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "extention"
        can :read, Invoice 
    when "regular_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "regular"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "regular"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "regular"
        can :manage, CollegePayment, admission_type: "regular"
        can :read, SemesterRegistration, admission_type: "regular"
        can :manage, Invoice
    when "distance_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "distance"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "distance"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "distance"
        can :manage, CollegePayment, admission_type: "distance"
        can :read, SemesterRegistration, admission_type: "distance"
        can :manage, Invoice
    when "online_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "online"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "online"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "online"
        can :manage, CollegePayment, admission_type: "online"
        can :read, SemesterRegistration, admission_type: "online"
        can :manage, Invoice
    when "extention_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "extention"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "extention"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "extention"
        can :manage, CollegePayment, admission_type: "extention"
        can :read, SemesterRegistration, admission_type: "extention"
        can :manage, Invoice        
    when "Stock Manager"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Product
        can :manage, Supplier
        can :manage, LocalVender
        can :manage, Catagory
        cannot :destroy, Catagory
        can :manage, Sale
        can :manage, ProductItem
        can :manage, CustomerNotification
        can :read, Customer
        can :manage, Purchase
        can :manage, PurchaseItem
        can :read, Notification, notifiable_type: "Product"
        can :read, Notification, notifiable_type: "PurchaseItem"
    when "Engineer"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Product
        can :read, Sale
        can :manage, Supplier
        can :manage, LocalVender
        can :read, Catagory
        can :manage, Customer
        can :read, Notification, notification_status: "Maintenance"
        # can :manage, Expense
        # can :manage, ActiveAdmin::Comment, resource_type: "Vacancy"
        # can :manage, ActiveAdmin::Comment, resource_type: "Order"
        # can :manage, ActiveAdmin::Comment, resource_type: "Product"
        # can :manage, ActiveAdmin::Comment, resource_type: "Advertisement"
    end
  end
end
