Feature: PostUrl Tag
  As a blogger who likes to write a variety of content
  I want to be able to link to posts easily
  And render them without much hassle

  Scenario: Basic site with a single page and a single post
    Given I have a _posts directory
    And I have the following post:
      | title       | date       | content           |
      | Hello World | 2019-02-04 | Lorem ipsum dolor |
    And I have an "index.md" page that contains "[Welcome]({% post_url 2019-02-04-hello-world %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/2019/02/04/hello-world.html\">Welcome</a></p>" in "_site/index.html"

  Scenario: Site with site-wide custom permalink setting and posts
    Given I have a _posts directory
    And I have the following posts:
      | title         | date       | content           |
      | Hello World   | 2019-02-04 | Lorem ipsum dolor |
      | We Meet Again | 2019-02-05 | Alpha beta gamma  |
    And I have a configuration file with "permalink" set to "/:title:output_ext"
    And I have an "index.md" page that contains "[Welcome]({% post_url 2019-02-04-hello-world %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/hello-world.html\">Welcome</a></p>" in "_site/index.html"

  Scenario: Site with permalink setting scoped to the post
    Given I have a _posts directory
    And I have the following posts:
      | title         | date       | permalink               | content           |
      | Hello World   | 2019-02-04 | "/2019/hello-world/"    | Lorem ipsum dolor |
      | We Meet Again | 2019-02-05 | "/2019/second-meeting/" | Alpha beta gamma  |
    And I have a configuration file with "permalink" set to "/:title:output_ext"
    And I have an "index.md" page that contains "[Welcome]({% post_url 2019-02-04-hello-world %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/2019/hello-world/\">Welcome</a></p>" in "_site/index.html"

  Scenario: Site with no posts
    Given I have an "index.md" page that contains "[Welcome]({% post_url 2019-02-04-hello-world %})"
    When I run jekyll build
    Then I should get a non-zero exit status
    And the _site directory should not exist
    But I should see "Could not find post \"2019-02-04-hello-world\" in tag 'post_url'." in the build output

  Scenario: Site with a future-dated post
    Given I have a _posts directory
    And I have the following posts:
      | title         | date       | content           |
      | Hello World   | 2019-02-04 | Lorem ipsum dolor |
      | We Meet Again | 2119-02-04 | Alpha beta gamma  |
    And I have a configuration file with "permalink" set to "/:title:output_ext"
    And I have an "index.md" page that contains "[Welcome Again]({% post_url 2119-02-04-we-meet-again %})"
    When I run jekyll build
    Then I should get a non-zero exit status
    And I should see "Could not find post \"2119-02-04-we-meet-again\" in tag 'post_url'." in the build output
    When I run jekyll build --future
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/we-meet-again.html\">Welcome Again</a></p>" in "_site/index.html"

  Scenario: Site with configured baseurl
    Given I have a _posts directory
    And I have the following posts:
      | title         | date       | content           |
      | Hello World   | 2019-02-04 | Lorem ipsum dolor |
      | We Meet Again | 2019-02-05 | Alpha beta gamma  |
    And I have a configuration file with "baseurl" set to "blog"
    And I have an "index.md" page that contains "[Welcome]({% post_url 2019-02-04-hello-world %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/2019/02/04/hello-world.html\">Welcome</a></p>" in "_site/index.html"
