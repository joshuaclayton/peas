Feature: View the homepage
  In order to see what the website is about
  As a visitor
  I want to read about "Peas"

  Scenario: View the homepage
    When I go to the homepage
    Then I should see "Peas"
    And I should see a field labeled "Enter your long URL"
