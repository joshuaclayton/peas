Feature: Generate shortened URLs
  In order to successfully shorten URLs
  As a visitor
  I want to enter long URLs and get back short URLs

  Scenario: Shorten a given URL
    When I go to the homepage
    And I fill in "Enter your long URL" with "http://www.google.com"
    And I press "Shorten"
    Then I should see "http://www.google.com was shortened to:"
    And I should see a short URL for "http://www.google.com"

  Scenario: Shorten a given URL when the URL exists
    Given a pea exists for the URL "http://www.google.com"
    When I go to the homepage
    And I fill in "Enter your long URL" with "http://www.google.com"
    And I press "Shorten"
    Then I should see "http://www.google.com was shortened to:"
    And I should see a short URL for "http://www.google.com"
