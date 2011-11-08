Feature: Sign in
  In order to get access to protected sections of the site
  User
  Should be able to sign in

    Scenario: User is not signed up
      Given no user exists with an email of "person@example.com"
      When I go to the user sign in page
      And I sign in as "person@example.com/password"
      Then I should see "Invalid email or password"

    Scenario: User is not confirmed
      Given I signed up with "person@example.com/password"
      When I go to the user sign in page
      And I sign in as "person@example.com/password"
      And I should see "You have to confirm your account before continuing."

    Scenario: User enters wrong password
      Given I am signed up and confirmed as "person@example.com/password"
      When I go to the user sign in page
      And I sign in as "person@example.com/wrongpassword"
      Then I should see "Invalid email or password"

    Scenario: User signs in successfully
      Given I am signed up and confirmed as "person@example.com/password"
      When I go to the user sign in page
      And I sign in as "person@example.com/password"
      Then I should see "Signed in"
      And I should be on the homepage
