Feature: frontmatter defaults
  Scenario: Use default for frontmatter variables internally
    Given I have a _layouts directory
    And I have a pretty layout that contains "THIS IS THE LAYOUT: {{content}}"

    And I have a _posts directory
    And I have the following post:
      | title             | date       | content          |
      | default layout    | 2013-09-11 | just some post   |
    And I have an "index.html" page with title "some title" that contains "just some page"

    And I have a configuration file with "defaults" set to "[{scope: {path: ""}, values: {layout: "pretty"}}]"

    When I run jekyll
    Then the _site directory should exist
    And I should see "THIS IS THE LAYOUT: <p>just some post</p>" in "_site/2013/09/11/default-layout.html"
    And I should see "THIS IS THE LAYOUT: just some page" in "_site/index.html"

  Scenario: Use default for frontmatter variables in Liquid
    Given I have a _posts directory
    And I have the following post:
      | title        | date       | content                                          |
      | default data | 2013-09-11 | <p>{{page.custom}}</p><div>{{page.author}}</div> |
    And I have an "index.html" page that contains "just {{page.custom}} by {{page.author}}"
    And I have a configuration file with "defaults" set to "[{scope: {path: ""}, values: {custom: "some special data", author: "Ben"}}]"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<p>some special data</p><div>Ben</div>" in "_site/2013/09/11/default-data.html"
    And I should see "just some special data by Ben" in "_site/index.html"

  Scenario: Override frontmatter defaults by path
    Given I have a _layouts directory
    And I have a root layout that contains "root: {{ content }}"
    And I have a subfolder layout that contains "subfolder: {{ content }}"

    And I have a _posts directory
    And I have the following post:
      | title | date       | content               |
      | about | 2013-10-14 | info on {{page.name}} |
    And I have a special/_posts directory
    And I have the following post in "special":
      | title | date       | path  | content               |
      | about | 2013-10-14 | local | info on {{page.name}} |

    And I have an "index.html" page with title "overview" that contains "Overview for {{page.name}}"
    And I have an "special/index.html" page with title "section overview" that contains "Overview for {{page.name}}"

    And I have a configuration file with "defaults" set to "[{scope: {path: ""}, values: {layout: "root", name: "the webpage"}}, {scope: {path: "special"}, values: {layout: "subfolder", name: "the special section"}}]"

    When I run jekyll
    Then the _site directory should exist
    And I should see "root: <p>info on the webpage</p>" in "_site/2013/10/14/about.html"
    And I should see "subfolder: <p>info on the special section</p>" in "_site/special/2013/10/14/about.html"
    And I should see "root: Overview for the webpage" in "_site/index.html"
    And I should see "subfolder: Overview for the special section" in "_site/special/index.html"

  Scenario: Override frontmatter defaults by type
    Given I have a _posts directory
    And I have the following post:
      | title          | date       | content |
      | this is a post | 2013-10-14 | blabla  |
    And I have an "index.html" page that contains "interesting stuff"
    And I have a configuration file with "defaults" set to "[{scope: {path: ""}, values: {permalink: "/perma.html"}}, {scope: {path: "", type: "post"}, values: {permalink: "/post.html"}}, {scope: {path: "", type: "page"}, values: {permalink: "/page.html"}}]"
    When I run jekyll
    Then I should see "blabla" in "_site/post.html"
    And I should see "interesting stuff" in "_site/page.html"
    But the "_site/perma.html" file should not exist

  Scenario: Actual frontmatter overrides defaults
    Given I have a _posts directory
    And I have the following post:
      | title    | date       | permalink         | author   | content                   |
      | override | 2013-10-14 | /frontmatter.html | some guy | a blog by {{page.author}} |
    And I have an "index.html" page with permalink "override.html" that contains "nothing"
    And I have a configuration file with "defaults" set to "[{scope: {path: ""}, values: {permalink: "/perma.html", author: "Chris"}}]"
    When I run jekyll
    Then I should see "a blog by some guy" in "_site/frontmatter.html"
    And I should see "nothing" in "_site/override.html"
    But the "_site/perma.html" file should not exist
