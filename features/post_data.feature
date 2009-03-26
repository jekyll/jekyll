Feature: Post data
  As a hacker who likes to blog
  I want to be able to embed data into my posts
  In order to make the posts slightly dynamic

  Scenario: Use post.title variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post for "3/26/2009" with title "Star Wars" and with layout "simple" and with content "C3P0!!"
    And I have a simple layout that contains "Post title: {{ post.title }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post title: Star Wars" in "_site/2009/03/26/star-wars.html"

  Scenario: Use post.url variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post for "3/26/2009" with title "Star Wars" and with layout "simple" and with content "C3P0!!"
    And I have a simple layout that contains "Post url: {{ post.url }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post url: /2009/03/26/star-wars.html" in "_site/2009/03/26/star-wars.html"

  Scenario: Use post.date variable
  Scenario: Use post.id variable
  Scenario: Use post.content variable
  Scenario: Use post.categories variable when category is in a folder
  Scenario: Use post.categories variable when categories are in folders
  Scenario: Use post.categories variable when categories are in YAML
  Scenario: Use post.categories variable when category is in YAML
  Scenario: Use post.topics variable
  Scenario: Disable a post from being published
  Scenario: Use a custom variable
