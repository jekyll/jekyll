Feature: Draft Posts
  As a hacker who likes to blog
  I want to be able to preview drafts locally
  In order to see if they look alright before publishing

  Scenario: Preview a draft
    Given I have a configuration file with "permalink" set to "none"
    And I have a _drafts directory
    And I have the following draft:
      | title  | date       | layout  | content        |
      | Recipe | 2009-03-27 | default | Not baked yet. |
    When I run jekyll build --drafts
    Then the _site directory should exist
    And I should see "Not baked yet." in "_site/recipe.html"

  Scenario: Don't preview a draft
    Given I have a configuration file with "permalink" set to "none"
    And I have an "index.html" page that contains "Totally index"
    And I have a _drafts directory
    And I have the following draft:
      | title  | date       | layout  | content        |
      | Recipe | 2009-03-27 | default | Not baked yet. |
    When I run jekyll build
    Then the _site directory should exist
    And the "_site/recipe.html" file should not exist

  Scenario: Don't preview a draft that is not published
    Given I have a configuration file with "permalink" set to "none"
    And I have an "index.html" page that contains "Totally index"
    And I have a _drafts directory
    And I have the following draft:
      | title  | date       | layout  | published | content        |
      | Recipe | 2009-03-27 | default | false     | Not baked yet. |
    When I run jekyll build --drafts
    Then the _site directory should exist
    And the "_site/recipe.html" file should not exist

  Scenario: Use page.path variable
    Given I have a configuration file with "permalink" set to "none"
    And I have a _drafts directory
    And I have the following draft:
      | title  | date       | layout | content                    |
      | Recipe | 2009-03-27 | simple | Post path: {{ page.path }} |
    When I run jekyll build --drafts
    Then the _site directory should exist
    And I should see "Post path: _drafts/recipe.markdown" in "_site/recipe.html"
