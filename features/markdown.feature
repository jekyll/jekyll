Feature: Markdown
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs

  Scenario: Markdown in list on index
    Given I have a configuration file with "paginate" set to "5"
    And I have an "index.html" page that contains "Index - {% for post in site.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date      | content    | type     |
      | Hackers | 2009-03-27 | # My Title | markdown |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1 id='my_title'>My Title</h1>" in "_site/2009/03/27/hackers.html"
    And I should see "<h1 id='my_title'>My Title</h1>" in "_site/index.html"

  Scenario: Markdown in pagination on index
    Given I have a configuration file with "paginate" set to "5"
    And I have an "index.html" page that contains "Index - {% for post in paginator.posts %} {{ post.content }} {% endfor %}"
    And I have a _posts directory
    And I have the following post:
      | title   | date      | content    | type     |
      | Hackers | 2009-03-27 | # My Title | markdown |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Index" in "_site/index.html"
    And I should see "<h1 id='my_title'>My Title</h1>" in "_site/index.html"

  Scenario: Output MathML with Maruku
    Given I have a "math.md" page that contains "$x^{n}$"
    And I have a configuration file with:
      | key      | value                                                         |
      | markdown | maruku                                                        |
      | maruku   | { use_tex: true, use_math_ml: true, math_ml_engine: 'ritex' } |
    When I run jekyll
    Then the _site directory should exist
    And I should see "<math (class='maruku-mathml'\s*|display='inline'\s*|xmlns='http://www.w3.org/1998/Math/MathML'\s*){3}><msup><mi>x</mi><mrow><mi>n</mi></mrow></msup></math>" in "_site/math.html"
