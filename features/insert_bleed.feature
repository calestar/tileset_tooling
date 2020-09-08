Feature: App inserts bleed correctly
  Simple test to validate that the bleed around tiles
  is added correctly when running the full executable

  Scenario: Insert bleed has help
    When I get help for bleed insert
    Then the exit status should be 0

  Scenario: Insert bleed without margin
    When I insert bleed to test data "simple_no_margin.png"
    Then I type "16"
    Then I type "16"
    Then I type "0"
    Then I type "0"
    Then I type "0"
    Then the exit status should be 1
    Then the output should contain "Current implementation needs an existing margin"

  Scenario: Insert bleed generate default output
    When I insert bleed to test data "simple_with_margin.png"
    Then I type "16"
    Then I type "16"
    Then I type "1"
    Then I type "0"
    Then I type "0"
    Then the exit status should be 0
    Then generated file should be the same as data result "simple_with_margin.png"

  Scenario: Insert bleed specific output
    When I insert bleed to test data "simple_with_margin.png" and output to "test_output.png"
    Then I type "16"
    Then I type "16"
    Then I type "1"
    Then I type "0"
    Then I type "0"
    Then the exit status should be 0
    Then generated file should be the same as data result "simple_with_margin.png"

  Scenario: Insert bleed with specs
    When I insert bleed to test data "simple_with_specs.png"
    Then the exit status should be 0
    Then generated file should be the same as data result "simple_with_specs.png"
