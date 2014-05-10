Feature: Create posts
  As a hacker who likes to blog
  I want to be able to start a new post
  In order to publish some new content

  Scenario: Create a new post
    Given I have a _posts directory
    When I run jekyll post "Wicked Content"
    Then a post from today with the name "wicked-content.markdown" should contain "title: Wicked Content"

  Scenario: Overwrite create a post that already exists
    Given I have a _posts directory
    And I have the following post:
    | title          | type  | date  | content                     |
    | Wicked Content | about | TODAY | This is some wicked content |
    When I run jekyll post "Wicked Content" --force
    Then a post from today with the name "wicked-content.markdown" should contain "layout: post"

  Scenario: Create a new post with the textile format
    Given I have a _posts directory
    When I run jekyll post "Textile post" --type textile
    Then a post from today with the name "textile-post.textile" should contain "title: Textile post"

  Scenario: Create a new post with the about layout
    Given I have a _posts directory
    When I run jekyll post "About me" --layout about
    Then a post from today with the name "about-me.markdown" should contain "layout: about"

  Scenario: Create a new post specifying a date
    Given I have a _posts directory
    When I run jekyll post "Old Post" --date 2013-07-31
    Then the "_posts/2013-07-31-old-post.markdown" file should exist
