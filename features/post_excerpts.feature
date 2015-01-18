Feature: Post excerpts
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But some people can only focus for a few moments
  So just give them a taste

  Scenario: An excerpt without a layout
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then the _site directory should exist
    And I should see exactly "<p>content for entry1.</p>" in "_site/index.html"

  Scenario: An excerpt from a post with a layout
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ page.excerpt }}"
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then the _site directory should exist
    And the _site/2007 directory should exist
    And the _site/2007/12 directory should exist
    And the _site/2007/12/31 directory should exist
    And the "_site/2007/12/31/entry1.html" file should exist
    And I should see exactly "<p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see exactly "<p>content for entry1.</p>" in "_site/index.html"

  Scenario: An excerpt from a post with a layout which has context
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "<html><head></head><body>{{ page.excerpt }}</body></html>"
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then the _site directory should exist
    And the _site/2007 directory should exist
    And the _site/2007/12 directory should exist
    And the _site/2007/12/31 directory should exist
    And the "_site/2007/12/31/entry1.html" file should exist
    And I should see "<p>content for entry1.</p>" in "_site/index.html"
    And I should see "<html><head></head><body><p>content for entry1.</p>\n\n</body></html>" in "_site/2007/12/31/entry1.html"
