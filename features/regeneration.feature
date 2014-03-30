Feature: Incremental Regeneration
  As a hacker who likes to blog
  I want Jekyll to only regenerate changed files
  So that I don't wait so long for my site to build

  @wip
  Scenario: Basic Site
    Given I have an "index.html" file that contains "Basic Site"
    And the site has not yet been built
    When I run jekyll
    Then the _site directory should exist
    And I should see "Basic Site" in "_site/index.html"

  @wip
  Scenario: Basic site already built
    Given I have an "index.html" file that contains "Basic Site"
    And the site has already been built
    When I run jekyll
    Then the _site directory should exist
    And "_site/index.html" should not have been regenerated

  @wip
  Scenario: Changing a post
    Given I have a _posts directory
    And I have the following posts:
      | title                   | date       | layout   | content              |
      | The Empire Strikes Back | 2013-11-22 | starwars | Hoth is really cold. |
      | Return of the Jedi      | 2013-11-22 | starwars | Hoth is really cold. |
    And the site has already been built
    When I change the "The Empire Strikes Back" post
    And I run jekyll
    Then the "The Empire Strikes Back" post should be regenerated
    And the "Return of the Jedi" post should not be regenerated

  @wip
  Scenario: Changing a layout
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following posts:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
      | Red Dwarf | 2010-01-02 | simple | They're dead, Dave.     |
      | Star Trek | 2009-04-02 | space  | The final frontier.     |
    And I have a layout that contains "{{ content }}"
    When I change the simple layout
    And I run jekyll
    Then the "Star Wars" post should be regenerated
    And the "Red Dwarf" post should be regenerated
    And the "Star Trek" post should not be regenerated

