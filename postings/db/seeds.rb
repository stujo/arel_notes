# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def postings_faker_title
  Faker::Commerce.product_name
end

def postings_faker_content
  Faker::Lorem.paragraph(5, true, 5)
end

bob = User.find_or_initialize_by(email: 'bob@example.com') do |user|
  user.password= 'password123'
  user.password_confirmation= 'password123'
  user.save!
end

mary = User.find_or_initialize_by(email: 'mary@example.com') do |user|
  user.password= 'password123'
  user.password_confirmation= 'password123'
  user.save!
end

jack = User.find_or_initialize_by(email: 'jack@example.com') do |user|
  user.password= 'password123'
  user.password_confirmation= 'password123'
  user.save!
end

10.times do |i|
  Post.create!(user: jack, title: postings_faker_title, content: postings_faker_content, public: 0 == i % 2)
  Post.create!(user: bob, title: postings_faker_title, content: postings_faker_content, public: 0 == i % 3)
  Post.create!(user: mary, title: postings_faker_title, content: postings_faker_content, public: 0 == i % 5)
end
