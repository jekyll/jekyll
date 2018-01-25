Feature: Collections Directory
  As a hacker who likes to structure content without clutter
  I want to be able to organize my collections under a single directory
  And render them from there

  Scenario: Custom collections_dir containing only posts
    And I have a collections/_posts directory
    And I have the following post within the "collections" directory:
      | title         | date       | content         |
      | Gathered Post | 2009-03-27 | Random Content. |
    And I have a "_config.yml" file with content:
    """
    collections_dir: collections
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Random Content." in "_site/2009/03/27/gathered-post.html"

  Scenario: Rendered collection in custom collections_dir also containing posts
    Given I have a collections/_puppies directory
    And I have the following document under the "puppies" collection within the "collections" directory:
      | title  | date       | content            |
      | Rover  | 2007-12-31 | content for Rover. |
    And I have a collections/_posts directory
    And I have the following post within the "collections" directory:
      | title         | date       | content         |
      | Gathered Post | 2009-03-27 | Random Content. |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true

    collections_dir: collections
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover.html" file should exist
    And I should see "Random Content." in "_site/2009/03/27/gathered-post.html"

  Scenario: Rendered collection in custom collections_dir with posts at the site root
    Given I have a collections/_puppies directory
    And I have the following document under the "puppies" collection within the "collections" directory:
      | title  | date       | content            |
      | Rover  | 2007-12-31 | content for Rover. |
    And I have a _posts directory
    And I have the following post:
      | title        | date       | content         |
      | Post At Root | 2009-03-27 | Random Content. |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true

    collections_dir: collections
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover.html" file should exist
    And the "_site/2009/03/27/post-at-root.html" file should not exist
    And the _site/_posts directory should not exist

  Scenario: Rendered collection in custom collections_dir also containing drafts
    Given I have a collections/_puppies directory
    And I have the following document under the "puppies" collection within the "collections" directory:
      | title  | date       | content            |
      | Rover  | 2007-12-31 | content for Rover. |
    And I have a collections/_drafts directory
    And I have the following draft within the "collections" directory:
      | title          | date       | content         |
      | Gathered Draft | 2009-03-27 | Random Content. |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true

    collections_dir: collections
    """
    When I run jekyll build --drafts
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover.html" file should exist
    And I should see "Random Content." in "_site/2009/03/27/gathered-draft.html"
    And the _site/collections directory should not exist

  Scenario: Rendered collection in custom collections_dir with drafts at the site root
    Given I have a collections/_puppies directory
    And I have the following document under the "puppies" collection within the "collections" directory:
      | title  | date       | content            |
      | Rover  | 2007-12-31 | content for Rover. |
    And I have a _drafts directory
    And I have the following draft:
      | title         | date       | content         |
      | Draft At Root | 2009-03-27 | Random Content. |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true

    collections_dir: collections
    """
    When I run jekyll build --drafts
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover.html" file should exist
    And the "_site/2009/03/27/draft-at-root.html" file should not exist

  Scenario: A complex site with collections posts and drafts at various locations
    Given I have a gathering/_puppies directory
    And I have a gathering/_posts directory
    And I have a gathering/_drafts directory
    And I have a _puppies directory
    And I have a _posts directory
    And I have a _drafts directory
    And I have the following document under the "puppies" collection within the "gathering" directory:
      | title               | date       | content            |
      | Rover in Gathering  | 2007-12-31 | content for Rover. |
    And I have the following document under the puppies collection:
      | title               | date       | content            |
      | Rover At Root       | 2007-12-31 | content for Rover. |
    And I have the following post within the "gathering" directory:
      | title               | date       | content            |
      | Post in Gathering   | 2009-03-27 | Totally nothing.   |
    And I have the following post:
      | title               | date       | content            |
      | Post At Root        | 2009-03-27 | Totally nothing.   |
    And I have the following draft within the "gathering" directory:
      | title               | date       | content            |
      | Draft In Gathering  | 2009-03-27 | This is a draft.   |
    And I have the following draft:
      | title               | date       | content            |
      | Draft At Root       | 2009-03-27 | This is a draft.   |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true

    collections_dir: gathering
    """
    And I have a "gathering/_puppies/static_file.txt" file that contains "Static content."
    And I have a gathering/_puppies/nested directory
    And I have a "gathering/_puppies/nested/static_file.txt" file that contains "Nested Static content."
    When I run jekyll build --drafts
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover-in-gathering.html" file should exist
    And the "_site/2009/03/27/post-in-gathering.html" file should exist
    And the "_site/2009/03/27/draft-in-gathering.html" file should exist
    And the "_site/2009/03/27/draft-at-root.html" file should not exist
    And the "_site/puppies/rover-at-root.html" file should not exist
    And I should see exactly "Static content." in "_site/puppies/static_file.txt"
    And I should see exactly "Nested Static content." in "_site/puppies/nested/static_file.txt"
    And the _site/gathering directory should not exist
    And the _site/_posts directory should not exist
