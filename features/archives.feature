Feature: Archives
  As a blog's user
  In order to find posts by year, category, or tag
  I want to have archive pages

  Scenario: Post with a date
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | null   | Luke, I am your father. |
    And I have a archive layout that contains "{% for post in site.posts %}{{ post.title }}{% endfor %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Star Wars" in "_site/archive/2009/index.html"

  Scenario: Post with a category in YAML front-matter
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 | category |
      | Star Wars | 2009-03-27 | null   | Luke, I am your father. | quotes   |
    And I have a archive layout that contains "{% for post in site.posts %}{{ post.title }}{% endfor %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Star Wars" in "_site/category/quotes/index.html"

  Scenario: Post with a category specified by directory
    Given I have a quotes directory
    And I have a quotes/_posts directory
    And I have a _layouts directory
    And I have the following post in "quotes":
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | null   | Luke, I am your father. |
    And I have a archive layout that contains "{% for post in site.posts %}{{ post.title }}{% endfor %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Star Wars" in "_site/category/quotes/index.html"

  Scenario: Post with tags
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 | tags             |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. | star-wars movies |
    And I have a archive layout that contains "{% for post in site.posts %}{{ post.title }}{% endfor %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Star Wars" in "_site/tag/star-wars/index.html"
    And I should see "Star Wars" in "_site/tag/movies/index.html"
