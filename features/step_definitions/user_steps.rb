Given /^no user exists with an email of "([^"]*)"$/ do |email|
    user = User.where(:email => email).first
    user.destroy if user
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  steps %{
    When I fill in "Email" with "#{email}"
    And I fill in "Password" with "#{password}"
    And I press "Sign in"
  }
end

Given /^I signed up with "(.*)\/(.*)"$/ do |email, password|
  user = User.where(:email => email).first
  user ||= Factory(:user, :email => email,
                   :password => password,
                   :password_confirmation => password)
end

Given /^I am signed up and confirmed as "(.*)\/(.*)"$/ do |email,password|
  steps %{
    Given I signed up with "#{email}/#{password}"
    And I have confirmed "#{email}"
  }
end

Given /^I have confirmed "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  user.confirm!
end

Given /^I am signed in as a complete user$/ do
  user = Factory(:complete_user, :password => "password")
  steps %{
    Given I am signed up and confirmed as "#{user.email}/password"
  }
end

Then /^a user should exist with email "([^"]*)"$/ do |email|
  fetch_user(email).should_not be_nil
end

Given %{I am signed in as a user with email "$email"} do |email|
  password = "test123"
  user = Factory(:confirmed_user,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)

  steps %{
    When I go to the user sign in page
    And I fill in "Email" with "#{email}"
    And I fill in "Password" with "#{password}"
    And I press "Sign in"
  }
end
