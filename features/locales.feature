Feature: Localization Support
  As a polyglot blogger who likes to write
  I want to be able to easily switch my site localization
  And render non-content strings accordingly

  Scenario: Default configuration
    Given I have an "index.md" page that contains "{{ locale.greeting }} Visitor!"
    And I have a _data/locales directory
    And I have a "_data/locales/en.yml" file that contains "greeting: Hello"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello Visitor!" in "_site/index.html"

  Scenario: Default configuration with custom locale
    Given I have an "index.md" page that contains "{{ locale.greeting }} Visitor!"
    And I have a configuration file with "locale" set to "pirate"
    And I have a _data/locales directory
    And I have a "_data/locales/pirate.yml" file that contains "greeting: Ahoy there"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Ahoy there Visitor!" in "_site/index.html"

  Scenario: Custom configuration and custom locale
    Given I have an "index.md" page that contains "{{ locale.greeting }} Visitor!"
    And I have a configuration file with:
      | key         | value     |
      | locales_dir | languages |
      | locale      | pirate    |
    And I have a _data/locales directory
    And I have a _data/languages directory
    And I have a "_data/locales/pirate.yml" file that contains "greeting: Valar Morghulis"
    And I have a "_data/languages/pirate.yml" file that contains "greeting: Ahoy there"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Ahoy there Visitor!" in "_site/index.html"

  Scenario: Custom configuration and custom locales in a single data file
    Given I have an "index.md" page that contains "{{ locale.greeting }} Visitor!"
    And I have a configuration file with:
      | key         | value     |
      | locales_dir | languages |
      | locale      | pirate    |
    And I have a _data directory
    And I have a "_data/languages.yml" file with content:
    """
    en:
      greeting: Welcome

    pirate:
      greeting: Ahoy there
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Ahoy there Visitor!" in "_site/index.html"

  Scenario: Locale data file with atypical keys
    Given I have an "index.md" page that contains "{{ locale.good_morning }} Visitor!"
    And I have a configuration file with:
      | key         | value     |
      | locales_dir | languages |
      | locale      | polyglot  |
    And I have a _data directory
    And I have a "_data/languages.yml" file with content:
    """
    polyglot:
      good_morning : Good Morning
      Good Morning : Goede morgen
      Good-Morning : Bonjour
      Good.Morning : Buenos días
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Buenos días Visitor!" in "_site/index.html"
