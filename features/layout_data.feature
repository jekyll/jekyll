Feature: Layout data
  As a hacker who likes to avoid repetition
  I want to be able to embed data into my layouts
  In order to make the layouts slightly dynamic

  Scenario: Use custom layout data
    Given I have a _layouts directory
    And I have a "_layouts/custom.html" file with content:
      """
      ---
      foo: my custom data
      ---
      {{ content }} foo: {{ layout.foo }}
      """
    And I have an "index.html" page with layout "custom" that contains "page content"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "page content\n foo: my custom data" in "_site/index.html"

  Scenario: Inherit custom layout data
    Given I have a _layouts directory
    And I have a "_layouts/custom.html" file with content:
      """
      ---
      layout: base
      foo: my custom data
      ---
      {{ content }}
      """
    And I have a "_layouts/base.html" file with content:
      """
      {{ content }} foo: {{ layout.foo }}
      """
    And I have an "index.html" page with layout "custom" that contains "page content"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "page content\n foo: my custom data" in "_site/index.html"

  Scenario: Inherit custom layout data
    Given I have a _layouts directory
    And I have a "_layouts/default.html" file with content:
      """
      {{ content }} foo: '{{ layout.foo }}'
      """
    And I have a "_layouts/special.html" file with content:
      """
      ---
      layout: default
      foo: my special data
      ---
      {{ content }}
      """
    And I have a "_layouts/page.html" file with content:
      """
      ---
      layout: default
      ---
      {{ content }}
      """
    And I have an "index.html" page with layout "special" that contains "page content"
    And I have an "jekyll.html" page with layout "page" that contains "page content"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "page content\n foo: 'my special data'" in "_site/index.html"
    And I should see "page content\n foo: ''" in "_site/jekyll.html"
