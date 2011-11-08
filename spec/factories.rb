Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :name do |n|
  "user_name#{n}"
end

Factory.sequence(:fb_user_id) {|n| "fb_user_id_#{n}" }

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.first_name            { "craig" }
  user.last_name             { "douglas" }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :complete_user, :parent => :user do
end

Factory.define :confirmed_user, :parent => :user do |confirmed_user|
  confirmed_user.after_create do |user|
    user.confirm!
  end
end
