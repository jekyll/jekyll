Feature: Markdown
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs

  Scenario: Markdown in list on index
    Given I have a configuration file with "paginate" set to "5"
    And I have an "index.html" page that contains "Index - {% for post in site.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date       | content    | type     |
      | Hackers | 2009-03-27 | # My Title | markdown |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1 id=\"my-title\">My Title</h1>" in "_site/2009/03/27/hackers.html"
    And I should see "<h1 id=\"my-title\">My Title</h1>" in "_site/index.html"

  Scenario: Markdown in pagination on index
    Given I have a configuration file with:
      | key      | value             |
      | paginate | 5                 |
      | gems     | [jekyll-paginate] |
    And I have an "index.html" page that contains "Index - {% for post in paginator.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date       | content    | type     |
      | Hackers | 2009-03-27 | # My Title | markdown |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1 id=\"my-title\">My Title</h1>" in "_site/index.html"
