Feature: Rendering
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But I want to make it as simply as possible
  So render with Liquid and place in Layouts

  Scenario: Render Liquid and place in layout
    Given I have a "index.html" page with layout "simple" that contains "Hi there, Jekyll {{ jekyll.environment }}!"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Hi there, Jekyll development!\nAhoy, indeed" in "_site/index.html"

  Scenario: Don't place asset files in layout
    Given I have an "index.scss" page with layout "simple" that contains ".foo-bar { color:black; }"
    And I have an "index.coffee" page with layout "simple" that contains "whatever()"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then the _site directory should exist
    And I should not see "Ahoy, indeed!" in "_site/index.css"
    And I should not see "Ahoy, indeed!" in "_site/index.js"

  Scenario: Don't render liquid in Sass
    Given I have an "index.scss" page that contains ".foo-bar { color:{{site.color}}; }"
    When I run jekyll build
    Then the _site directory should not exist
    And I should see "Invalid CSS after" in the build output

  Scenario: Don't render liquid in CoffeeScript
    Given I have an "index.coffee" page that contains "hey='for {{site.animal}}'"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "hey = 'for {{site.animal}}';" in "_site/index.js"
