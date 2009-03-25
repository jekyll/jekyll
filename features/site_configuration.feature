Feature: Site configuration
  As a hacker who likes to blog
  I want to be able to configure jekyll
  In order to make setting up a site easier

  Scenario: Change destination directory
    Given I have a blank site
    And I have an "index.html" file that contains "Changing destination directory"
    And a configuration file with "site" set to "_mysite"
    When I run jekyll
    Then the _mysite directory should exist
    And I should see "Basic Site" in "_mysite/index.html"

  Scenario: Use RDiscount for markup
  Scenario: Use Maruku for markup
  Scenario: Disable auto-regeneration
  Scenario: Run server on a different server port
  Scenario: Use no permalink schema
  Scenario: Use pretty permalink schema
  Scenario: Highlight code with pygments
