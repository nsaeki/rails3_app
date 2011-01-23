require "faker"

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relatinships
  end

  def make_users
    admin = User.create!(:name => "Administrator", 
                         :login_name => "admin",
                         :email => "admin@example.com",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      login_name = "user-#{n+1}"
      email = "user-#{n+1}@example.org"
      password = "password"
      User.create!(:name => name,
                   :login_name => login_name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
  
  def make_microposts
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
  
  def make_relatinships
    users = User.all
    user = users.first
    following = users[1..50]
    followers = users[3..40]
    following.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
  end
end