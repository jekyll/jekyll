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

