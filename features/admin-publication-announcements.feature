Feature: Announcing an upcoming publication
  As an publisher of government statistics
  I want to be able to announce upcoming statistical publications
  So that citizens can see which statistical publications are forthcoming and when they will be published.

  Scenario: announcing a statistical publication
    Given I am a writer
    When I make an announcement for a statistical publication called "Monthly Beard Stats"
    Then I should see the announcement for "Monthly Beard Stats" on my dashboard
