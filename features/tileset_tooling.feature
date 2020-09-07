Feature: App executes correctly
  Simple test to validate that the app starts correctly, makes
  debugging of failing tests easier

  Scenario: App just runs
    When I get help
    Then the exit status should be 0
