Feature: Permalink template in page
  As a hacker who likes flexibility in page destination paths
  I want to be able to define permalink template per page

  Scenario: permalink template in a CSS page
    Given I have a "screen.css" page with permalink "/:path/other:output_ext" that contains "p { font-size: 16px; }"
    When I run jekyll build
    Then the "_site/other.css" file should exist
    And I should see "p { font-size: 16px; }" in "_site/other.css"

  Scenario: permalink template with fingerprint in an SCSS page referring to itself
    Given I have an "index.html" page that contains "Asset URL: {% fingerprint_url screen.scss %}"
    And I have a "screen.scss" page with permalink "/:path/:basename-:fingerprint:output_ext" that contains "p { background-image: url('{{ page.url }}') }"
    When I run jekyll build
    Then the "_site/screen-583e4344009f65ddad8c7d2c293863c2.css" file should exist
    And I should see "p {\n  background-image: url\(\"/screen-583e4344009f65ddad8c7d2c293863c2\.css\"\); }" in "_site/screen-583e4344009f65ddad8c7d2c293863c2.css"
    And I should see "Asset URL: /screen-583e4344009f65ddad8c7d2c293863c2.css" in "_site/index.html"
