Feature: Theme Inheritance
  As a developer who publishes gem-based themes
  I want to be able to publish customizations to an existing theme-gem
  Without having to include the entire parent theme in the package

  Scenario: Inheriting a parent theme's layouts
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have a "test.md" page with layout "test-layout" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"

  Scenario: Using layouts from the child theme
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have an "test.md" page with layout "unique" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "unique.html from test-theme-inheritance:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"

  Scenario: Overriding layouts in the child theme
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    And I have a "test.md" page with layout "unique" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme-inheritance:" in "_site/test.html"
    And I should see "<p>Hello!</p>" in "_site/test.html"
    Given I have a _layouts directory
    And I have an "_layouts/unique.html" file that contains "from source directory: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from source directory: <p>Hello!</p>" in "_site/test.html"

  Scenario: Overriding layouts in a child theme that overrode a parent theme's layout
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a "test.md" page with layout "override" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme: <p>Hello!</p>" in "_site/test.html"
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from test-theme-inheritance: <p>Hello!</p>" in "_site/test.html"
    Given I have a _layouts directory
    And I have an "_layouts/override.html" file that contains "from source directory: {{ content }}"
    And I have a "test.md" page with layout "override" that contains "Hello!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "from source directory: <p>Hello!</p>" in "_site/test.html"

  Scenario: Inheriting a parent theme's assets
    Given I have a configuration file with "theme" set to "test-theme"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your theme" in "_site/assets/base.js"
    But the "_site/assets/another.js" file should not exist
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your theme" in "_site/assets/base.js"
    And I should see "Another from theme inheritance" in "_site/assets/another.js"

  Scenario: Inheriting a parent theme's default configuration
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a "test.md" page that contains "{{ site.title }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello World" in "_site/test.html"
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello World" in "_site/test.html"

  Scenario: Inheriting a parent theme's stylesheets
    Given I have a configuration file with:
      | key         | value       |
      | theme       | test-theme  |
      | theme-color | black       |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "color: black" in "_site/assets/style.css"
    Given I have a configuration file with:
      | key         | value                  |
      | theme       | test-theme-inheritance |
      | theme-color | black                  |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".sample { color: black; }" in "_site/assets/style.css"
  
  Scenario: Overriding stylesheets in the child theme that overrode a parent theme's stylesheet
    Given I have a configuration file with "theme" set to "test-theme"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".another-sample { color: blue; }" in "_site/assets/style.css"
    Given I have a configuration file with "theme" set to "test-theme-inheritance"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".another-sample { color: brown; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: blue; }" in "_site/assets/style.css"
    Given I have a _sass directory
    And I have an "_sass/another-sample.scss" file that contains ".another-sample { color: purple; }"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".another-sample { color: purple; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: blue; }" in "_site/assets/style.css"
    But I should not see ".another-sample { color: brown; }" in "_site/assets/style.css"
