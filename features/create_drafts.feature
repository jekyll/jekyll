Feature: Create drafts
  As a hacker who likes to blog
  I want to be able to start a new draft
  In order to work on content that isn't ready for publishing

  Scenario: Create a new draft
    Given I have a _drafts directory
    And I do not have a "_drafts/test-post.markdown" file
    When I run jekyll draft "Test post"
    Then the "_drafts/test-post.markdown" file should exist
    And I should see "layout: post" in "_drafts/test-post.markdown"
    And I should see "title: Test post" in "_drafts/test-post.markdown"

  Scenario: Overwrite create a draft that already exists
    Given I have a _drafts directory
    And I have a "_drafts/test-post.markdown" file that contains "---\nlayout: about\ntitle: A long post name\n---"
    When I run jekyll draft "Test post" --force
    Then the "_drafts/test-post.markdown" file should exist
    And I should see "layout: post" in "_drafts/test-post.markdown"
    And I should see "title: Test post" in "_drafts/test-post.markdown"

  Scenario: Create a new draft with the textile format
    Given I have a _drafts directory
    And I do not have a "_drafts/textile-post.textile" file
    When I run jekyll draft "Textile post" --type textile
    Then the "_drafts/textile-post.textile" file should exist

  Scenario: Create a new draft with the about layout
    Given I have a _drafts directory
    And I do not have a "_drafts/about-me.markdown" file
    When I run jekyll draft "About me" --layout about
    Then the "_drafts/about-me.markdown" file should exist
    And I should see "layout: about" in "_drafts/about-me.markdown"
