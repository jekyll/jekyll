Feature: Collections
  As a hacker who likes to structure content
  I want to be able to create collections of similar information
  And render them

  Scenario: Unrendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have fixture collections
    And I have a configuration file with "collections" set to "['methods']"
    When I debug jekyll
    Then the _site directory should exist
    And I should see "Collections: {\"methods\"=>#<Jekyll::Collection @label=methods docs=\[#<Jekyll::Document _methods/configuration.md collection=methods>, #<Jekyll::Document _methods/sanitized_path.md collection=methods>, #<Jekyll::Document _methods/site/generate.md collection=methods>, #<Jekyll::Document _methods/site/initialize.md collection=methods>, #<Jekyll::Document _methods/um_hi.md collection=methods>\]>}" in "_site/index.html"

  Scenario: Rendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.collections.methods.label }}"
    And I have fixture collections
    And I have a configuration file with:
      | key         | value       |
      | collections | ['methods'] |
      | render      | \n  methods: /methods/:subdir/:title:extname |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Collections: methods" in "_site/index.html"
    And I should see "Whatever: foo.bar" in "_site/methods/configuration.html"