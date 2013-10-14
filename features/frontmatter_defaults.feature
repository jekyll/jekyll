Feature: frontmatter defaults
  Scenario: Use default for frontmatter variables internally
    Given I have a _posts directory
    And I have a _layouts directory
    And I have a configuration file with "defaults" set to "[{scope: {path: "", type: "post"}, values: {layout: "pretty"}}]"
    And I have a pretty layout that contains "THIS IS THE LAYOUT: {{content}}"
    And I have the following post:
      | title          | date       | content        |
      | default layout | 2013-09-11 | Just some post |
    When I run jekyll
    Then the _site directory should exist
    And I should see "THIS IS THE LAYOUT: <p>Just some post</p>" in "_site/2013/09/11/default-layout.html"

  Scenario: Use default for frontmatter variables in Liquid
    Given I have a _posts directory
    And I have a configuration file with "defaults" set to "[{scope: {path: "", type: "post"}, values: {custom: "some special data", author: "Ben"}}]"
    And I have the following post:
      | title        | date       | author | content                                          |
      | default data | 2013-09-11 | Marc   | <p>{{page.custom}}</p><div>{{page.author}}</div> |
    When I run jekyll
    Then the _site directory should exist
    And I should see "<p>some special data</p><div>Marc</div>" in "_site/2013/09/11/default-data.html"
