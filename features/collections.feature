Feature: Collections
  As a hacker who likes to structure content
  I want to be able to create collections of similar information
  And render them

  Scenario: Unrendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.methods }}"
    And I have fixture collections
    And I have a configuration file with "collections" set to "['methods']"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Collections: Use `{{ page.title }}` to build a full configuration for use w/Jekyll.\n\nWhatever: {{ page.whatever }}\n`{{ page.title }}` is used to make sure your path is in your source.\nRun your generators! {{ page.layout }}\nCreate dat site.\nRun your generators! {{ page.layout }}" in "_site/index.html"

  Scenario: Rendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have fixture collections
    And I have a configuration file with:
      | key         | value       |
      | collections | ['methods'] |
      | render      | ['methods'] |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Collections: methods" in "_site/index.html"
    And I should see "<p>Whatever: foo.bar</p>" in "_site/methods/configuration.html"

  Scenario: Rendered document in a layout
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have a default layout that contains "<div class='title'>Tom Preston-Werner</div> {{content}}"
    And I have fixture collections
    And I have a configuration file with:
      | key         | value       |
      | collections | ['methods'] |
      | render      | ['methods'] |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Collections: methods" in "_site/index.html"
    And I should see "<p>Run your generators! default</p>" in "_site/methods/site/generate.html"
    And I should see "<div class='title'>Tom Preston-Werner</div>" in "_site/methods/site/generate.html"