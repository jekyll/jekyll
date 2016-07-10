Feature: Fancy permalinks
  As a hacker who likes to blog
  I want to be able to set permalinks
  In order to make my blog URLs awesome

  Scenario: Use none permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                 | date       | content          |
      | None Permalink Schema | 2009-03-27 | Totally nothing. |
    And I have a configuration file with "permalink" set to "none"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally nothing." in "_site/none-permalink-schema.html"

  Scenario: Use pretty permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                   | date       | content            |
      | Pretty Permalink Schema | 2009-03-27 | Totally wordpress. |
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally wordpress." in "_site/2009/03/27/pretty-permalink-schema/index.html"

  Scenario: Use pretty permalink schema for pages
    Given I have an "index.html" page that contains "Totally index"
    And I have an "awesome.html" page that contains "Totally awesome"
    And I have an "sitemap.xml" page that contains "Totally uhm, sitemap"
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally index" in "_site/index.html"
    And I should see "Totally awesome" in "_site/awesome/index.html"
    And I should see "Totally uhm, sitemap" in "_site/sitemap.xml"

  Scenario: Use custom permalink schema with prefix
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date       | content         |
      | Custom Permalink Schema | stuff    | 2009-03-27 | Totally custom. |
    And I have a configuration file with "permalink" set to "/blog/:year/:month/:day/:title/"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally custom." in "_site/blog/2009/03/27/custom-permalink-schema/index.html"

  Scenario: Use custom permalink schema with category
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date       | content         |
      | Custom Permalink Schema | stuff    | 2009-03-27 | Totally custom. |
    And I have a configuration file with "permalink" set to "/:categories/:title.html"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally custom." in "_site/stuff/custom-permalink-schema.html"

  Scenario: Use custom permalink schema with squished date
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date       | content         |
      | Custom Permalink Schema | stuff    | 2009-03-27 | Totally custom. |
    And I have a configuration file with "permalink" set to "/:month-:day-:year/:title.html"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally custom." in "_site/03-27-2009/custom-permalink-schema.html"

  Scenario: Use custom permalink schema with date and time
    Given I have a _posts directory
    And I have the following post:
      | title                   | category | date                | content         |
      | Custom Permalink Schema | stuff    | 2009-03-27 22:31:07 | Totally custom. |
    And I have a configuration file with:
      | key         | value              |
      | permalink   | "/:year:month:day:hour:minute:second.html" |
      | timezone    | UTC                |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally custom." in "_site/20090327223107.html"

  Scenario: Use per-post permalink
    Given I have a _posts directory
    And I have the following post:
      | title     | date       | permalink       | content |
      | Some post | 2013-04-14 | /custom/posts/1/ | bla bla |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the _site/custom/posts/1 directory should exist
    And I should see "bla bla" in "_site/custom/posts/1/index.html"

  Scenario: Use per-post ending in .html
    Given I have a _posts directory
    And I have the following post:
      | title     | date       | permalink               | content |
      | Some post | 2013-04-14 | /custom/posts/some.html | bla bla |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the _site/custom/posts directory should exist
    And I should see "bla bla" in "_site/custom/posts/some.html"

  Scenario: Use pretty permalink schema with cased file name
    Given I have a _posts directory
    And I have an "_posts/2009-03-27-Pretty-Permalink-Schema.md" page that contains "Totally wordpress"
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally wordpress." in "_site/2009/03/27/Pretty-Permalink-Schema/index.html"

  Scenario: Use custom permalink schema with cased file name
    Given I have a _posts directory
    And I have an "_posts/2009-03-27-Custom-Schema.md" page with title "Custom Schema" that contains "Totally awesome"
    And I have a configuration file with "permalink" set to "/:year/:month/:day/:slug/"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally awesome" in "_site/2009/03/27/custom-schema/index.html"

  Scenario: Use pretty permalink schema with title containing underscore
    Given I have a _posts directory
    And I have an "_posts/2009-03-27-Custom_Schema.md" page with title "Custom Schema" that contains "Totally awesome"
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Totally awesome" in "_site/2009/03/27/Custom_Schema/index.html"

  Scenario: Use a non-HTML file extension in the permalink
    Given I have a _posts directory
    And I have an "_posts/2016-01-18-i-am-php.md" page with permalink "/2016/i-am-php.php" that contains "I am PHP"
    And I have a "i-am-also-php.md" page with permalink "/i-am-also-php.php" that contains "I am also PHP"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "I am PHP" in "_site/2016/i-am-php.php"
    And I should see "I am also PHP" in "_site/i-am-also-php.php"
