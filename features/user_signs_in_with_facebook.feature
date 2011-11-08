Feature: Sign in with Facebook Connect
  In order to use their Facebook credentials for authentication.
  An existing user
  Should be able to sign in with Facebook Connect

  Background:
    Given I am signed into Facebook with the following information:
      | access token | 123                              |
      | email        | joe@example.com                  |
      | link         | http://facebook.com/user_example |
      | first_name   | Pema                             |
      | last_name    | Geyleg                           |

  Scenario: User signs up and in with facebook
    Given the following confirmed user exists:
      | email           |
      | joe@example.com |
    When I go to the user sign in page
    And I follow "Sign in with Facebook"
    Then I should see "Successfully authorized from Facebook account"
    And I should be on the homepage
    And I should see "Logout"
