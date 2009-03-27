Feature: Post data
  As a hacker who likes to blog
  I want to be able to embed data into my posts
  In order to make the posts slightly dynamic

  Scenario: Use post.title variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post title: {{ post.title }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post title: Star Wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.url variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post url: {{ post.url }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post url: /2009/03/27/star-wars.html" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.date variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post date: {{ post.date }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post url: 2009-03-27" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.id variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post id: {{ post.id }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post id: /2009/03/27/star-wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.content variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post content: {{ post.content }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post content: Luke, I am your father." in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in a folder
    Given I have a blank site
    And I have a movies directory
    And I have a movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies":
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ post.categories }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in folders
    Given I have a blank site
    And I have a movies directory
    And I have a movies/scifi directory
    And I have a movies/scifi/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies/scifi":
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post categories: {{ post.categories }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post categories: movies scifi" in "_site/movies/scifi/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in YAML
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | category | content                 |
      | Star Wars | 3/27/2009 | simple | movies   | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ post.categories }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post categories: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in YAML
    Given I have a blank site
    And I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout | categories    | content                 |
      | Star Wars | 3/27/2009 | simple | movies, scifi | Luke, I am your father. |
    And I have a simple layout that contains "Post categories: {{ post.categories }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post categories: movies scifi" in "_site/movies/scifi/2009/03/27/star-wars.html"

  Scenario: Use post.topics variable
    Given I have a blank site
    And I have a _posts directory
    And I have a _posts/movies directory
    And I have a _posts/movies/scifi directory
    And I have the following post:
      | title     | date      | layout | content                 |
      | Star Wars | 3/27/2009 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post topics: {{ post.topics }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post topics: movies scifi" in "_site/2009/03/27/star-wars.html"

  Scenario: Disable a post from being published
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title     | date      | layout | published | content                 |
      | Star Wars | 3/27/2009 | simple | false     | Luke, I am your father. |
    When I run jekyll
    Then the _site directory should exist
    And the "_site/2009/03/27/star-wars.html" file should not exist

  Scenario: Use a custom variable
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title     | date      | layout | author      | content                 |
      | Star Wars | 3/27/2009 | simple | Darth Vader | Luke, I am your father. |
    And I have a simple layout that contains "Post author: {{ post.author }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Post author: Darth Vader" in "_site/2009/03/27/star-wars.html"
