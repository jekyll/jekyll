Feature: Multi-Level Theme Inheritance
  As a developer who publishes gem-based themes
  I want to be able to publish customizations to an existing theme-gem that itself is customized from another existing theme-gem
  Without having to include the entire parent theme and all of its parent themes in the package

  Scenario: Inheriting ancestor themes' layouts
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    And I have a "test.md" page with layout "test-layout" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    And I have a "test.md" page with layout "unique" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "unique.html from test-theme-inheritance:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"

  Scenario: Using layouts from the child theme
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    And I have an "test.md" page with layout "override" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "override.html from test-theme-inheritance-multi-level:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"

  Scenario: Overriding layouts in the child theme
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    And I have a "test.md" page with layout "unique-to-multi-level" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme-inheritance-multi-level:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"
    Given I have a _layouts directory
    And I have an "_layouts/unique-to-multi-level.html" file that contains "from source directory: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from source directory: <p>Hello!</p>" in "_site/test.html"

  Scenario: Overriding layouts in a child theme that overrode an ancestor theme's layout
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a "test.md" page with layout "override" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme: <p>Hello!</p>" in "_site/test.html"
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme-inheritance-multi-level: <p>Hello!</p>" in "_site/test.html"
    Given I have a _layouts directory
    And I have an "_layouts/override.html" file that contains "from source directory: {{ content }}"
    And I have a "test.md" page with layout "override" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from source directory: <p>Hello!</p>" in "_site/test.html"

  Scenario: Inheriting ancestor themes' assets
    Given I have a configuration file with "theme" set to "test-theme"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your theme" in "_site/assets/base.js"
    But the "_site/assets/another.js" file should not exist
    And the "_site/assets/another-multi-level.js" file should not exist
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your theme" in "_site/assets/base.js"
    And I should see "Another from theme inheritance" in "_site/assets/another.js"
    And I should see "Another from theme inheritance multi level" in "_site/assets/another-multi-level.js"

  Scenario: Inheriting ancestor themes' default configurations
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a "test.md" page that contains "{{ site.title }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello World" in "_site/test.html"
    Given I have a configuration file with "theme" set to "test-theme-inheritance-multi-level"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello World" in "_site/test.html"

  Scenario: Inheriting ancestor themes' stylesheets
    Given I have a configuration file with:
      | key         | value       |
      | theme       | test-theme  |
      | theme-color | red         |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "color: red" in "_site/assets/style.css"
    Given I have a configuration file with:
      | key         | value                              |
      | theme       | test-theme-inheritance-multi-level |
      | theme-color | red                                |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".sample { color: red; }" in "_site/assets/style.css"
  
  Scenario: Overriding stylesheets in the child theme that overrode a parent theme's stylesheet
    Given I have a configuration file with:
      | key         | value         |
      | theme       | test-theme    |
      | theme-color | black         |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".sample { color: black; }" in "_site/assets/style.css"
    And I should see ".another-sample { color: blue; }" in "_site/assets/style.css"
    Given I have a configuration file with:
      | key         | value                                |
      | theme       | test-theme-inheritance-multi-level   |
      | theme-color | black                                |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".sample { color: black; background-color: white; }" in "_site/assets/style.css"
    And I should see ".another-sample { color: royalblue; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: blue; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: brown; }" in "_site/assets/style.css"
    Given I have a _sass directory
    And I have an "_sass/another-sample.scss" file that contains ".another-sample { color: purple; }"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".another-sample { color: purple; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: blue; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: brown; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: royalblue; }" in "_site/assets/style.css"
