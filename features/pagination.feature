Feature: Site pagination
  In order to paginate my blog
  As a blog's user
  I want divide the posts in several pages
  
  Scenario Outline: Paginate with N posts per page
    Given I have a configuration file with "paginate" set to "<num>"
    And I have a _layouts directory
    And I have an "index.html" file that contains "Basic Site"
    And I have a _posts directory
    And I have the following post:
      | title     | date      | layout  | content                                |
      | Wargames  | 3/27/2009 | default | The only winning move is not to play.  |
      | Wargames2 | 4/27/2009 | default | The only winning move is not to play2. |
      | Wargames3 | 5/27/2009 | default | The only winning move is not to play2. |
    When I run jekyll
    Then the _site/page2 directory should exist
    And the _site/page2/index.html file should exist

    Examples:
      | num |
      | 1   |
      | 2   |

  Scenario: Correct liquid paginator replacements
    Given I have a configuration file with "paginate" set to "1"
    And I have a _layouts directory
    And I have an "index.html" file that contains "{{ paginator.page }}"
    And I have a _posts directory
    And I have the following post:
      | title     | date      | layout  | content                                |
      | Wargames  | 3/27/2009 | default | The only winning move is not to play.  |
      | Wargames2 | 4/27/2009 | default | The only winning move is not to play2. |
    When I run jekyll
    Then the _site/index.html file should exist
    And I should see "1" in "_site/index.html"
    Then the _site/page2 directory should exist
    And the _site/page2/index.html file should exist
    And I should see "2" in "_site/page2/index.html"
    