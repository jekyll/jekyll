Feature: Inheriting from a gem-based theme
  As a theme author
  I want to build one theme on top of another
  So that I can distribute focused customizations without copying an entire theme

  Scenario: A child theme inherits and overrides parent resources
    Given I have a configuration file with "theme" set to "test-theme-child"
    And I have an "index.html" page with layout "default" that contains "{% include include.html %} {% include child.html %} {{ site.data.cars.manufacturer }} {{ site.data.greetings.child }}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "default.html from test-theme" in "_site/index.html"
    And I should see "include.html from test-theme-child" in "_site/index.html"
    And I should see "child.html from test-theme-child" in "_site/index.html"
    And I should see "Mercedes" in "_site/index.html"
    And I should see "Child theme data" in "_site/index.html"
    And I should see "From the child theme." in "_site/assets/base.js"
    And I should see "Unique to the child theme." in "_site/assets/child.js"
    And I should see "color: blue" in "_site/assets/child.css"
    And I should see "color: black" in "_site/assets/child.css"
    And the "_site/assets/img/logo.png" file should exist

  Scenario: A site overrides a child theme
    Given I have a configuration file with "theme" set to "test-theme-child"
    And I have an _includes directory
    And I have an "_includes/include.html" file that contains "include.html from the site"
    And I have an "index.html" page with layout "child" that contains "{% include include.html %}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "child.html from test-theme-child" in "_site/index.html"
    And I should see "include.html from the site" in "_site/index.html"
    And I should not see "include.html from test-theme-child" in "_site/index.html"
