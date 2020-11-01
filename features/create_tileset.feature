Feature: App creates tilesets correctly
  Simple test to validate that tilesets are created correctly by the tool

  Scenario: Create tileset has help
    When I get help for create tileset
    Then the exit status should be 0

  Scenario: Create tileset without specs, margin or offset
    When I create a new tileset
    Then I type "16"
    Then I type "16"
    Then I type "0"
    Then I type "0"
    Then I type "0"
    Then I type "2"
    Then I type "3"
    Then I type "1"
    Then the exit status should be 0
    Then generated file should be the same as data result "create_nomargin_nooffset.png"

  Scenario: Create tileset while output already exists and we don't overwrite
    When Tileset creation file already exists
    And I create a new tileset without overwriting output
    Then the exit status should be 1

  Scenario: Create tileset with specs
    When I create a new tileset using specs "create_nomargin_nooffset.specs"
    Then the exit status should be 0
    Then generated file should be the same as data result "create_nomargin_nooffset.png"

  Scenario: Create tileset with specs with header
    When I create a new tileset using specs "create_1pxmargin_nooffset.specs"
    Then the exit status should be 0
    Then generated file should be the same as data result "create_1pxmargin_nooffset.png"
    Then generated specs file should be the same as specs result "create_1pxmargin_nooffset.specs"
