Feature: Inheriting gem-based themes
  As a theme author
  I want to extend an installed parent theme
  So that users can select one child theme without copying the parent files

  Scenario: Building inherited layouts and assets
    Given I have a configuration file with "theme" set to "test-child-theme"
    And I have an "index.html" page with layout "inherited" that contains "{% include shared.html %}{% include parent-only.html %}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "parent-layout:" in "_site/index.html"
    And I should see "child-shared-include" in "_site/index.html"
    And I should see "parent-only-include" in "_site/index.html"
    And I should see "parent-only-asset" in "_site/assets/parent-only.txt"
    And I should see "child-shared-asset" in "_site/assets/shared.txt"
    And I should see "color: blue" in "_site/assets/inherited.css"
    And I should see "width: 12px" in "_site/assets/inherited.css"

  Scenario: Site resources override both theme layers
    Given I have a configuration file with "theme" set to "test-child-theme"
    And I have an _includes directory
    And I have an "_includes/shared.html" file that contains "local-include"
    And I have an "index.html" page with layout "inherited" that contains "{% include shared.html %}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "parent-layout:local-include" in "_site/index.html"
    And I should not see "child-shared-include" in "_site/index.html"

  Scenario: Configuration inherits parent defaults but site values win
    Given I have a "_config.yml" file with content:
      """
      theme: test-child-theme
      theme_options:
        shared: local-config
      """
    And I have an "index.html" page that contains "{{ site.theme_options.parent_only }}|{{ site.theme_options.child_only }}|{{ site.theme_options.shared }}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "parent-config|child-config|local-config" in "_site/index.html"
