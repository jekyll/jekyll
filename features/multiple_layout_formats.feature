Feature: Multiple layout formats
  As an author publishing the same content in several formats
  I want layouts with the same basename to produce separate files
  So I can provide an HTML page and machine-readable data from one source

  Scenario: Rendering a page through HTML and JSON layouts
    Given I have a "index.md" page with layout "event" that contains "Hello"
    And I have a _layouts directory
    And I have a "_layouts/event.html" file that contains "<main>{{ content }}</main>"
    And I have a "_layouts/event.json" file that contains "{{ content | strip_html | strip | jsonify }}"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "<main><p>Hello</p>" in "_site/index.html"
    And I should see "\"Hello\"" in "_site/index.json"

  Scenario: Inheriting the parent layout with the matching format
    Given I have a "index.md" page with layout "event" that contains "Hello"
    And I have a _layouts directory
    And I have a "_layouts/event.html" file with content:
      """
      ---
      layout: base
      ---
      HTML {{ content }}
      """
    And I have a "_layouts/event.json" file with content:
      """
      ---
      layout: base
      ---
      {{ content | strip_html | strip | jsonify }}
      """
    And I have a "_layouts/base.html" file that contains "<main>{{ content }}</main>"
    And I have a "_layouts/base.json" file with content:
      """
      {"content": {{ content }}}
      """
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "<main>HTML <p>Hello</p>" in "_site/index.html"
    And I should see "\"content\": \"Hello\"" in "_site/index.json"
