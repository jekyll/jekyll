Feature: Create sites
  As a hacker who likes to blog
  I want to publish a draft
  In order to share it with the world

  Scenario: Publish a draft
    Given I have a _drafts directory
    And I have a _posts directory
    And I have the following draft:
    | title             | type     | content              |
    | a-completed-draft | markdown | this is some content |
    When I run jekyll publish a-completed-draft.markdown
    Then the "_drafts/a-completed-draft.markdown" file should not exist
    And a post from today with the name "a-completed-draft.markdown" should contain "this is some content"

  Scenario: Publish a draft with a specific date
    Given I have a _drafts directory
    And I have a _posts directory
    And I have the following draft:
    | title             | type     |
    | a-completed-draft | markdown |
    When I run jekyll publish a-completed-draft.markdown --date "Sept 25 1920"
    Then the "_drafts/a-completed-draft.markdown" file should not exist
    And the "_posts/1920-09-25-a-completed-draft.markdown" file should exist
