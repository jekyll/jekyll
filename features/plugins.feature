Feature: Configuring and using plugins
  As a hacker
  I want to specify my own plugins that can modify Jekyll's behaviour

  Scenario: Add a gem-based plugin
    Given I have an "index.html" file that contains "Whatever"
    And I have a configuration file with "gems" set to "[jekyll_test_plugin]"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Whatever" in "_site/index.html"
    And I should see "this is a test" in "_site/test.txt"

  Scenario: Add an empty whitelist to restrict all gems
    Given I have an "index.html" file that contains "Whatever"
    And I have a configuration file with:
      | key       | value                |
      | gems      | [jekyll_test_plugin] |
      | whitelist | []                   |
    When I run jekyll build --safe
    Then the _site directory should exist
    And I should see "Whatever" in "_site/index.html"
    And the "_site/test.txt" file should not exist

  Scenario: Add a whitelist to restrict some gems but allow others
    Given I have an "index.html" file that contains "Whatever"
    And I have a configuration file with:
      | key       | value                                              |
      | gems      | [jekyll_test_plugin, jekyll_test_plugin_malicious] |
      | whitelist | [jekyll_test_plugin]                               |
    When I run jekyll build --safe
    Then the _site directory should exist
    And I should see "Whatever" in "_site/index.html"
    And the "_site/test.txt" file should exist
    And I should see "this is a test" in "_site/test.txt"
