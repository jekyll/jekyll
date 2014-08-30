Feature: Permalink template in page
  As a hacker who likes flexibility in page destination paths
  I want to be able to define permalink template per page

  Scenario: permalink template in a CSS page
    Given I have a "screen.css" page with permalink "/:path/other:output_ext" that contains "p { font-size: 16px; }"
    When I run jekyll build
    Then the "_site/other.css" file should exist
    And I should see "p { font-size: 16px; }" in "_site/other.css"
