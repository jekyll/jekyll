Feature: Bundling Config file with Theme gems
  As a web developer who likes to share my expertise
  I want to be able to pre-configure my gemified theme
  In order to make it easier for other Jekyllites to use my theme

  Scenario: Easy onboarding with a pre-configured theme
    Given I have a configuration file with "theme" set to "test-theme"
    And I have an "index.md" page that contains "{{ site.test_theme.skin }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "aero" in "_site/index.html"

  Scenario: A pre-configured theme with valid config file overriding Jekyll defaults
    Given I have a configuration file with "theme" set to "test-theme"
    And I have an "index.md" page that contains "{{ site.baseurl }}"
    And I have a node_modules directory
    And I have a "node_modules/alert.js" file that contains "alert('foo');"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/index.html" file should exist
    But the "_site/node_modules/alert.js" file should not exist
    And the "_site/extras/banner.html" file should not exist
    And I should not see "/test-theme" in "_site/index.html"
