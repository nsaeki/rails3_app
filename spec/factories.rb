Factory.define :user do |user|
  user.name "Example User"
  user.login_name {Factory.next(:login_name)}
  user.email {Factory.next(:email)}
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :login_name do |n|
  "person-#{n}"
end
