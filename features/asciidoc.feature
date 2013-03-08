Feature: AsciiDoc
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs

  Scenario: AsciiDoc in list on index
    Given I have a configuration file with "paginate" set to "5"
    And I have an "index.html" page that contains "Index - {% for post in site.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date      | content    | type     |
      | Hackers | 3/2/2013  | = My Title | asciidoc |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1>My Title</h1>" in "_site/2013/03/02/hackers.html"
    And I should see "<h1>My Title</h1>" in "_site/index.html"

  Scenario: AsciiDoc in pagination on index
    Given I have a configuration file with "paginate" set to "5"
    And I have an "index.html" page that contains "Index - {% for post in paginator.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date      | content    | type     |
      | Hackers | 3/2/2013  | = My Title | asciidoc |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1>My Title</h1>" in "_site/index.html"
    
