# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

roles = %w(super_admin site_admin content_manager)
roles.each do |role|
  Role.find_or_create_by(name: role)
end

# delete test data
if ENV['delete_test_user_accounts'].present?
  puts 'DELETING ALL TEST USER ACCOUNTS'
  User.where(email: ['super.admin@test.ge', 'site.admin@test.ge', 'content.manager@test.ge']).destroy_all
end

# if this is not production
# and variable is set, create users if not exist
if ENV['create_test_user_accounts'].present? && !Rails.env.production?
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

# delete test data
if (ENV['load_test_data'].present? || ENV['delete_test_data'].present?) && !Rails.env.production?
  puts 'DELETING ALL EXISTING DATA (categories, experiments, etc)'
  Category.destroy_all
  Experiment.destroy_all
end

# load test data
if ENV['load_test_data'].present? && !Rails.env.production?
  puts 'CREATING CATEGORIES'
  path = "#{Rails.root}/db/test_data/"

  categories = []
  categories << Category.create(title: 'ბიოლოგია', color_hex: '#98d84d', logo: File.open(path + 'category_images/biology.svg'))
  categories << Category.create(title: 'ინჟინერია', color_hex: '#40b4f1', logo: File.open(path + 'category_images/engineering.svg'))
  categories << Category.create(title: 'ასტრონომია', color_hex: '#5e439c', logo: File.open(path + 'category_images/astronomy.svg'))
  categories << Category.create(title: 'ქიმია', color_hex: '#f9a334', logo: File.open(path + 'category_images/chemistry.svg'))
  categories << Category.create(title: 'ფიზიკა', color_hex: '#576adc', logo: File.open(path + 'category_images/physics.svg'))

  if File.exists?(path + 'experiments.csv')
    puts 'CREATING EXPERIMENTS'
    csv = CSV.read(path + 'experiments.csv')
    #columns:
    #0 - title
    #1 - intro
    #2 - ingredients
    #3 - directions
    #4 - explanation
    #5 - warning
    #6 - category
    #7 - adult supervision
    #8 - thumb1
    #9 - thumb2

    if csv.length > 1
      csv.each_with_index do |row, index|
        if index > 0
          puts "- adding experiment #{index}"
          category = categories.select{|x| x.title.downcase == row[6].downcase}.first if row[6].present?
          c_ids = category.present? ? [category.id] : nil
          e = Experiment.new(title: row[0], intro: row[1], explanation: row[4], warning: row[5], category_ids: c_ids, needs_adult_supervision: row[7].present? && row[7].downcase == 'true' ? true : false, is_active: true)
          ings = row[2].split("\n")
          dirs = row[3].split("\n")
          if ings.present?
            ings.each_with_index do |ing, ing_index|
              e.ingredients.build(content: ing, sort_order: ing_index+1)
            end
          end

          if dirs.present?
            dirs.each_with_index do |dir, dir_index|
              e.directions.build(content: dir, sort_order: dir_index+1)
            end
          end
          e.save
        end
      end
    end
  end
end
