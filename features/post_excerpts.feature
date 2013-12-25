Feature: Post excerpts
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But some people can only focus for a few moments
  So just give them a taste, if I want to

  Scenario: Without excerpt_separator set, nothing should appear
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ content }}"
    And I have the following posts:
      | title  | date       | layout | type     | content             |
      | entry1 | 2013-12-25 | post   | markdown | content for entry1. |
    When I run jekyll
    Then the "_site/2013/12/25/entry1.html" file should exist
    And I should see exactly "<p>content for entry1.</p>" in "_site/2013/12/25/entry1.html"
    And I should see nothing in "_site/index.html"

  Scenario: With an excerpt_separator set to <!-- more -->
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ content }}"
    And I have the following posts:
      | title  | date       | layout | type     | content                                         |
      | entry1 | 2013-12-25 | post   | markdown | content for entry1. <!-- more --> more content. |
    And I have a configuration file with "excerpt_separator" set to "<!-- more -->"
    When I run jekyll
    Then the "_site/2013/12/25/entry1.html" file should exist
    And I should see exactly "<p>content for entry1. <!-- more --> more content.</p>" in "_site/2013/12/25/entry1.html"
    And I should see exactly "<p>content for entry1.</p>" in "_site/index.html"
