Feature: Generate shortened URLs
  In order to successfully shorten URLs
  As a visitor
  I want to enter long URLs and get back short URLs

  Scenario: Shorten a given URL
    When I go to the homepage
    And I fill in "Enter your long URL" with "http://google.com"
    And I press "Shorten"
    Then I should see "http://google.com was shortened to:"
    And I should see a short URL for "http://google.com"

