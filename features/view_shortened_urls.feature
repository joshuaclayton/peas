Feature: View shortened URLs
  In order to visit the long URL
  As a visitor
  I should be able to visit the short URL and be redirected

  Scenario: Visit a shortened URL
    Given a pea exists for the URL "http://www.google.com"
    And the pea for "http://www.google.com" has the key "abc"
    When I visit the short URL for "abc"
    Then I should be redirected to "http://www.google.com"

  Scenario: Visit a nonexistant shortened URL
    Given a pea exists for the URL "http://www.google.com"
    And the pea for "http://www.google.com" has the key "abc"
    When I visit the short URL for "abcd"
    Then I should be on the homepage
