Feature: Syntax errors in the web page
  In order to find errors in my code faster
  I want to see syntax errors in the web page

  Scenario: When receiving a Liquid syntax error while building
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{% INVALID %}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid syntax error \(.+/invalid\.html line 1\): Unknown tag 'INVALID' included in index\.html" in the build output

  Scenario: When receiving a Liquid syntax error while serving
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{% INVALID %}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll serve
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid syntax error \(.+/invalid\.html line 1\): Unknown tag 'INVALID' included in index\.html" in the build output

  Scenario: When receiving a Liquid syntax error while serving with livereload
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{% INVALID %}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I serve jekyll with --livereload
    And   I should see "Liquid Exception: Liquid syntax error \(.+/invalid\.html line 1\): Unknown tag 'INVALID' included in index\.html" in the build output
    And   I should see "Failed to render" in "_site/index.html"
    And   I should see "Liquid syntax error" in "_site/index.html"
    And   I should see "Unknown tag 'INVALID' included  in index\.html" in "_site/index.html"
