Feature: postpermalink defaults
  Scenario: Define permalink default for posts
    Given I have a _posts directory
    And I have the following post:
      | title          | date       | category | content | 
      | testpost       | 2013-10-14 | blog     | blabla  |
    And I have a configuration file with "defaults" set to "[{scope: {path: "", type: "post"}, values: {permalink: ":categories/:title"}}]"
    When I run jekyll build
    Then I should see "blabla" in "blog/testpost/index.html"
