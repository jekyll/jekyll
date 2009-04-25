Feature: Fancy permalinks
  As a hacker who likes to blog
  I want to be able to set permalinks
  In order to make my blog URLs awesome

  Scenario: Use none permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                 | date      | content          |
      | None Permalink Schema | 3/27/2009 | Totally nothing. |
    And I have a configuration file with "permalink" set to "none"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally nothing." in "_site/none-permalink-schema.html"

  Scenario: Use pretty permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                   | date      | content            |
      | Pretty Permalink Schema | 3/27/2009 | Totally wordpress. |
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally wordpress." in "_site/2009/03/27/pretty-permalink-schema/index.html"

  Scenario: Use custom permalink schema with prefix
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to "blog/:year/:month/:day/:title"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/posts/2009/03/27/custom-permalink-scheme/index.html"

  Scenario: Use custom permalink schema with category
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to ":category/:title.html"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/stuff/custom-permalink-scheme.html"

  Scenario: Use custom permalink schema with squished date
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to ":month-:day-:year/:title.html"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/03-27-2009/custom-permalink-scheme.html"
