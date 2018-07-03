Feature: Writing themes
  As a hacker who likes to share my expertise
  I want to be able to make a gemified theme
  In order to share my awesome style skillz with other Jekyllites

  Scenario: Generating a new theme scaffold
    When I run jekyll new-theme my-cool-theme
    Then I should get a zero exit status
    And the my-cool-theme directory should exist

  Scenario: Generating a new theme scaffold with a code of conduct
    When I run jekyll new-theme my-cool-theme --code-of-conduct
    Then I should get a zero exit status
    And the my-cool-theme directory should exist
    And the "my-cool-theme/CODE_OF_CONDUCT.md" file should exist

  Scenario: A theme with SCSS
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a css directory
    And I have a "css/main.scss" page that contains "@import 'test-theme-black';"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".sample {\n  color: black; }" in "_site/css/main.css"

  Scenario: A theme with an include
    Given I have a configuration file with "theme" set to "test-theme"
    And I have an _includes directory
    And I have an "_includes/in_project.html" file that contains "I'm in the project."
    And I have an "index.html" page that contains "{% include in_project.html %} {% include include.html %}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "I'm in the project." in "_site/index.html"
    And I should see "<span class=\"sample\">include.html from test-theme</span>" in "_site/index.html"

  Scenario: A theme with a layout
    Given I have a configuration file with "theme" set to "test-theme"
    And I have an _layouts directory
    And I have an "_layouts/post.html" file that contains "post.html from the project: {{ content }}"
    And I have an "index.html" page with layout "default" that contains "I'm content."
    And I have a "post.html" page with layout "post" that contains "I'm more content."
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "default.html from test-theme: I'm content." in "_site/index.html"
    And I should see "post.html from the project: I'm more content." in "_site/post.html"

  Scenario: A theme with assets
    Given I have a configuration file with "theme" set to "test-theme"
    And I have an assets directory
    And I have an "assets/application.coffee" file that contains "From your site."
    And I have an "assets/base.js" file that contains "From your site."
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "From your site." in "_site/assets/application.coffee"
    And I should see "From your site." in "_site/assets/base.js"

  Scenario: Requiring dependencies of a theme
    Given I have a configuration file with "theme" set to "test-dependency-theme"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/test.txt" file should exist

  Scenario: Complicated site that puts it all together
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout  | content             |
      | entry1 | 2016-04-21 | post    | I am using a local layout. {% include include.html %} |
      | entry2 | 2016-04-21 | default | I am using a themed layout. {% include include.html %} {% include in_project.html %} |
    And I have a _layouts directory
    And I have a "_layouts/post.html" page with layout "default" that contains "I am a post layout! {{ content }}"
    And I have an _includes directory
    And I have an "_includes/in_project.html" file that contains "I am in the project, not the theme."
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "I am in the project, not the theme." in "_site/2016/04/21/entry2.html"
    And I should see "<span class=\"sample\">include.html from test-theme</span>" in "_site/2016/04/21/entry2.html"
    And I should see "default.html from test-theme:" in "_site/2016/04/21/entry2.html"
    And I should see "I am using a themed layout." in "_site/2016/04/21/entry2.html"
    And I should not see "I am a post layout!" in "_site/2016/04/21/entry2.html"
    And I should not see "I am in the project, not the theme." in "_site/2016/04/21/entry1.html"
    And I should see "<span class=\"sample\">include.html from test-theme</span>" in "_site/2016/04/21/entry1.html"
    And I should see "default.html from test-theme:" in "_site/2016/04/21/entry1.html"
    And I should see "I am using a local layout." in "_site/2016/04/21/entry1.html"
    And I should see "I am a post layout!" in "_site/2016/04/21/entry1.html"
