Feature: Rendering
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But I want to make it as simply as possible
  So render with Liquid and place in Layouts

  Scenario: When receiving bad Liquid
    Given I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception" in the build output

  Scenario: When receiving a liquid syntax error in included file
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{% INVALID %}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid syntax error \(.+/invalid\.html line 1\): Unknown tag 'INVALID' included in index\.html" in the build output

  Scenario: When receiving a generic liquid error in included file
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{{ site.title | prepend 'Prepended Text' }}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid error \(.+/_includes/invalid\.html line 1\): wrong number of arguments (\(given 1, expected 2\)|\(1 for 2\)) included in index\.html" in the build output

  Scenario: Render Liquid and place in layout
    Given I have a "index.html" page with layout "simple" that contains "Hi there, Jekyll {{ jekyll.environment }}!"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hi there, Jekyll development!\nAhoy, indeed" in "_site/index.html"

  Scenario: Don't place asset files in layout
    Given I have an "index.scss" page with layout "simple" that contains ".foo-bar { color:black; }"
    And I have an "index.coffee" page with layout "simple" that contains "whatever()"
    And I have a configuration file with "gems" set to "[jekyll-coffeescript]"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Ahoy, indeed!" in "_site/index.css"
    And I should not see "Ahoy, indeed!" in "_site/index.js"

  Scenario: Ignore defaults and don't place pages and documents with layout set to 'none'
    Given I have a "index.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a _trials directory
    And I have a "_trials/no-layout.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a "_trials/test.md" page with layout "null" that contains "Hi there, {{ site.author }}!"
    And I have a none layout that contains "{{ content }}Welcome!"
    And I have a page layout that contains "{{ content }}Check this out!"
    And I have a configuration file with:
    | key             | value                                          |
    | author          | John Doe                                       |
    | collections     | {trials: {output: true}}                       |
    | defaults        | [{scope: {path: ""}, values: {layout: page}}]  |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Welcome!" in "_site/trials/no-layout.html"
    And I should not see "Check this out!" in "_site/trials/no-layout.html"
    But I should see "Check this out!" in "_site/trials/test.html"
    And I should see "Hi there, John Doe!" in "_site/index.html"
    And I should not see "Welcome!" in "_site/index.html"
    And I should not see "Build Warning:" in the build output

  Scenario: Don't place pages and documents with layout set to 'none'
    Given I have a "index.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a _trials directory
    And I have a "_trials/no-layout.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a "_trials/test.md" page with layout "page" that contains "Hi there, {{ site.author }}!"
    And I have a none layout that contains "{{ content }}Welcome!"
    And I have a page layout that contains "{{ content }}Check this out!"
    And I have a configuration file with:
    | key             | value                     |
    | author          | John Doe                  |
    | collections     | {trials: {output: true}}  |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Welcome!" in "_site/trials/no-layout.html"
    And I should not see "Welcome!" in "_site/index.html"
    But I should see "Check this out!" in "_site/trials/test.html"
    And I should see "Hi there, John Doe!" in "_site/index.html"
    And I should not see "Build Warning:" in the build output

  Scenario: Render liquid in Sass
    Given I have an "index.scss" page that contains ".foo-bar { color:{{site.color}}; }"
    And I have a configuration file with "color" set to "red"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".foo-bar {\n  color: red; }" in "_site/index.css"

  Scenario: Not render liquid in CoffeeScript without explicitly including jekyll-coffeescript
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/index.js" file should not exist

  Scenario: Render liquid in CoffeeScript with jekyll-coffeescript enabled
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    And I have a configuration file with "gems" set to "[jekyll-coffeescript]"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "hey = 'for cicada';" in "_site/index.js"
