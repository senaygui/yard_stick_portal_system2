namespace :bill do
  task :monthly => :environment do
    puts "[#{Time.now}]] Create and send monthly bill to students"
    SemesterRegistration.where(mode_of_payment: "monthly").each do |sm|
      Invoice.create do |invoice|
        invoice.semester_registration_id = sm.id
        invoice.created_by = sm.created_by
        invoice.due_date = sm.created_at.day + 10.days 
        invoice.invoice_status = "not submitted"
        invoice.invoice_number = SecureRandom.random_number(1000..100000)
        tution_price = (sm.course_registrations.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: sm.study_level,admission_type: sm.admission_type).first.tution_per_credit_hr * oi.curriculum.credit_hour) : 0 }.sum) /4 
        invoice.total_price = tution_price
      end
    end
  end
  task :half => :environment do
    puts "[#{Time.now}]] Create and send half semester bill to students"
    SemesterRegistration.where(mode_of_payment: "half").each do |sm|
      Invoice.create do |invoice|
        invoice.semester_registration_id = sm.id
        invoice.created_by = sm.created_by
        invoice.due_date = sm.created_at.day + 10.days 
        invoice.invoice_status = "not submitted"
        invoice.invoice_number = SecureRandom.random_number(1000..100000)
        tution_price = (sm.course_registrations.collect { |oi| oi.valid? ? (CollegePayment.where(study_level: sm.study_level,admission_type: sm.admission_type).first.tution_per_credit_hr * oi.curriculum.credit_hour) : 0 }.sum) /2 
        invoice.total_price = tution_price 
      end
    end
  end
end

