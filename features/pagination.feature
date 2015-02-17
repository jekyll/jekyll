Feature: Site pagination
  In order to paginate my blog
  As a blog's user
  I want divide the posts in several pages

  Scenario Outline: Paginate with N posts per page
    Given I have a configuration file with:
      | key      | value             |
      | paginate | <num>             |
      | gems     | [jekyll-paginate] |
    And I have a _layouts directory
    And I have an "index.html" page that contains "{{ paginator.posts.size }}"
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | Wargames  | 2009-03-27 | default | The only winning move is not to play.  |
      | Wargames2 | 2009-04-27 | default | The only winning move is not to play2. |
      | Wargames3 | 2009-05-27 | default | The only winning move is not to play3. |
      | Wargames4 | 2009-06-27 | default | The only winning move is not to play4. |
    When I run jekyll build
    Then the _site/page<exist> directory should exist
    And the "_site/page<exist>/index.html" file should exist
    And I should see "<posts>" in "_site/page<exist>/index.html"
    And the "_site/page<not_exist>/index.html" file should not exist

    Examples:
      | num | exist | posts | not_exist |
      | 1   | 4     | 1     | 5         |
      | 2   | 2     | 2     | 3         |
      | 3   | 2     | 1     | 3         |

  Scenario Outline: Setting a custom pagination path
    Given I have a configuration file with:
      | key           | value                          |
      | paginate      | 1                              |
      | paginate_path | /blog/page-:num                |
      | permalink     | /blog/:year/:month/:day/:title |
      | gems          | [jekyll-paginate]              |
    And I have a blog directory
    And I have an "blog/index.html" page that contains "{{ paginator.posts.size }}"
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | Wargames  | 2009-03-27 | default | The only winning move is not to play.  |
      | Wargames2 | 2009-04-27 | default | The only winning move is not to play2. |
      | Wargames3 | 2009-05-27 | default | The only winning move is not to play3. |
      | Wargames4 | 2009-06-27 | default | The only winning move is not to play4. |
    When I run jekyll build
    Then the _site/blog/page-<exist> directory should exist
    And the "_site/blog/page-<exist>/index.html" file should exist
    And I should see "<posts>" in "_site/blog/page-<exist>/index.html"
    And the "_site/blog/page-<not_exist>/index.html" file should not exist

    Examples:
      | exist | posts | not_exist |
      | 2     | 1     | 5         |
      | 3     | 1     | 6         |
      | 4     | 1     | 7         |

  Scenario Outline: Setting a custom pagination path without an index.html in it
    Given I have a configuration file with:
      | key           | value                          |
      | paginate      | 1                              |
      | paginate_path | /blog/page/:num                |
      | permalink     | /blog/:year/:month/:day/:title |
      | gems          | [jekyll-paginate]              |
    And I have a blog directory
    And I have an "blog/index.html" page that contains "{{ paginator.posts.size }}"
    And I have an "index.html" page that contains "Don't pick me!"
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | Wargames  | 2009-03-27 | default | The only winning move is not to play.  |
      | Wargames2 | 2009-04-27 | default | The only winning move is not to play2. |
      | Wargames3 | 2009-05-27 | default | The only winning move is not to play3. |
      | Wargames4 | 2009-06-27 | default | The only winning move is not to play4. |
    When I run jekyll build
    Then the _site/blog/page/<exist> directory should exist
    And the "_site/blog/page/<exist>/index.html" file should exist
    And I should see "<posts>" in "_site/blog/page/<exist>/index.html"
    And the "_site/blog/page/<not_exist>/index.html" file should not exist

    Examples:
      | exist | posts | not_exist |
      | 2     | 1     | 5         |
      | 3     | 1     | 6         |
      | 4     | 1     | 7         |
