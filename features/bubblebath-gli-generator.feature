Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

#  Scenario: Generate a new bubblebath project
#    When I create a new bubblebath project
#    Then I should see the directory three in the terminal

  Scenario: App just runs
    When I get help for "bubblebath-gli-generator"
    Then the exit status should be 0
