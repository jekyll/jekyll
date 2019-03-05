Feature: Theme Inheritance
  As a developer who wants to use a pre-existing theme
  I want to be able to extend an existing theme
  In order to distribute my changes without having to watch for changes in the parent theme

  Scenario: A child theme using a parent theme's assets
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your theme" in "_site/assets/base.js"
    And I should see "Another from theme inheritance" in "_site/assets/another.js"

  Scenario: Layouts in the child theme overriding the parent theme's layouts
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have an "test.md" file with content:
      """
      ---
      layout: override
      ---
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "override.html from test-theme-inheritance" in "_site/test.html"
    And I should see ""

  Scenario: Using layouts from the parent theme are used
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have an "test.md" file with content:
      """
      ---
      layout: test-layout
      ---
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "test-layout.html from test-theme" in "_site/test.html"

  Scenario: Layouts from the child theme should be available
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have an "test.md" file with content:
      """
      ---
      layout: unique
      ---
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "unique.html from test-theme-inheritance" in "_site/test.html"
