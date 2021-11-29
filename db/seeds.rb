# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(first_name: "#{ENV['FIRST_NAME']}",last_name: "#{ENV['LAST_NAME']}", email: "#{ENV['ADMIN_EMAIL']}", password: "#{ENV['SEED_PASSWORD']}", password_confirmation: "#{ENV['SEED_PASSWORD']}", role: "#{ENV['ROLE']}") if Rails.env.development?


AdminUser.create!(first_name: "#{Rails.application.credentials.production[:first_name]}",   last_name: "#{Rails.application.credentials.production[:last_name]}",
									email: "#{Rails.application.credentials.production[:admin_email]}", 
									password: "#{Rails.application.credentials.production[:seed_password]}",password_confirmation: "#{Rails.application.credentials.production[:seed_password]}",  
									role: "#{Rails.application.credentials.production[:role]}") if Rails.env.production?