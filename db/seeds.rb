# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

roles = %w(super_admin site_admin content_manager)
roles.each do |role|
  Role.find_or_create_by(name: role)
end

# if this is not production
# and variable is set, create users if not exist
if ENV['create_user_accounts'].present? && !Rails.env.production?
  puts "LOADING TEST USER ACCOUNTS"
  User.find_or_create_by(email: 'super.admin@test.ge') do |u|
    puts "creating site admin"
    u.password = 'password123'
    u.role_id = 1
  end

  User.find_or_create_by(email: 'site.admin@test.ge') do |u|
    puts "creating site admin"
    u.password = 'password123'
    u.role_id = 2
  end

  User.find_or_create_by(email: 'content.manager@test.ge') do |u|
    puts "creating content manager"
    u.password = 'password123'
    u.role_id = 3
  end
end

# load test data
if ENV['load_test_data'].present? && !Rails.env.production?
  puts 'DELETING ALL EXISTING DATA (categories, experiments, etc)'
  Category.destroy_all

  puts 'CREATING CATEGORIES'
  Category.create(title: 'Biology', color_hex: '#98d84d')
  Category.create(title: 'Engineering', color_hex: '#40b4f1')
  Category.create(title: 'Astronomy', color_hex: '#5e439c')
  Category.create(title: 'Chemistry', color_hex: '#f9a334')
  Category.create(title: 'Physics', color_hex: '#576adc')

end
