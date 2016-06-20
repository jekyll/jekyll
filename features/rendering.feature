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
