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

  Scenario: Use pretty permalink schema for pages
    Given I have an "index.html" page that contains "Totally index"
    And I have an "awesome.html" page that contains "Totally awesome"
    And I have an "sitemap.xml" page that contains "Totally uhm, sitemap"
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally index" in "_site/index.html"
    And I should see "Totally awesome" in "_site/awesome/index.html"
    And I should see "Totally uhm, sitemap" in "_site/sitemap.xml"

  Scenario: Use custom permalink schema with prefix
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to "/blog/:year/:month/:day/:title"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/blog/2009/03/27/custom-permalink-schema/index.html"

  Scenario: Use custom permalink schema with category
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to "/:categories/:title.html"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/stuff/custom-permalink-schema.html"

  Scenario: Use custom permalink schema with squished date
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date      | content         |
      | Custom Permalink Schema | stuff    | 3/27/2009 | Totally custom. |
    And I have a configuration file with "permalink" set to "/:month-:day-:year/:title.html"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally custom." in "_site/03-27-2009/custom-permalink-schema.html"
