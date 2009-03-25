Feature: Create sites
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs

  Scenario: Basic site
    Given I have a blank site
    And I have an index file that contains "Basic Site"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Basic Site" in "index.html"

  Scenario: Basic site with a post
    Given I have a blank site
    And I have a post titled "Hackers" for "3/24/2009" that contains "My First Exploit"
    When I run jekyll
    Then the _site directory should exist
    And the _site/posts directory should exist
    And the _site/posts/2009/03/24/hackers.html file should exist
    And I should see "My First Exploit" in "_site/posts/2009/03/24/hackers.html"

  Scenario: Basic site with layout
    Given I have a blank site
    And I have an index file with a "default" layout that contains "Basic Site with Layout"
    And I have a default layout that contains "{{ content }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Basic Site with Layout" in "_site/index.html"

  Scenario: Basic site with layout and a post
    Given I have a blank site
    And I have a post titled "Hackers" for "3/24/2009" that contains "My First Exploit"
    And I have an index file with a "default" layout that contains "Basic Site with Layout and a Post: {{ first_post }}"
    And I have a default layout that contains "{{ content }}"
    When I run jekyll
    Then the _site directory should exist
    And the _site/posts directory should exist
    And the _site/posts/2009/03/24/hackers.html file should exist
    And I should see "My First Exploit" in "_site/posts/2009/03/24/hackers.html"
    And I should see "Basic Site with Layout and a Post: My First Exploit" in "_site/index.html"

  Scenario: Basic site with include tag
