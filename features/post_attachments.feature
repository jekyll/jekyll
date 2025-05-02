Feature: Post attachments
  As a hacker who likes to blog
  I want to be able to have assets alongside my posts
  In order to slightly ease management of post-specific assets

  Scenario: Attachments of posts in a standard site
    Given I have a _posts directory
    And I have the following posts with attachments:
      | title            | date       | content                 | attachments          |
      | Star Wars        | 2009-03-27 | Luke, I am your father. | pic070.png,cover.jpg |
      | Avengers-Endgame | 2019-03-27 | I am inevitable!        |                      |
    And I have a movies directory
    And I have the following post with attachments inside movies directory:
      | title            | date       | content          | attachments          |
      | Avengers-Endgame | 2019-03-27 | I am inevitable! | pic120.png,cover.jpg |
    And I have a post layout that contains "<pre>{{ page.attachments | jsonify }}</pre>"
    And I have a configuration file with "defaults" set to "[{scope: {type: posts}, values: {layout: post}}]"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/2009/03/27/cover.jpg" file should exist
    And the "_site/2009/03/27/pic070.png" file should exist
    And the "_site/movies/2019/03/27/cover.jpg" file should exist
    And the "_site/movies/2019/03/27/pic120.png" file should exist

  Scenario: Attachments of drafts in a standard site
    Given I have a _drafts directory
    And I have the following drafts with attachments:
      | title            | date       | content                 | attachments          |
      | Star Wars        | 2009-03-27 | Luke, I am your father. | pic070.png,cover.jpg |
      | Avengers-Endgame | 2019-03-27 | I am inevitable!        | screencap-001.png    |
    And I have an "index.md" page with content:
      """
      <pre>
      {% for post in site.posts -%}
        {{ post.attachments | jsonify }}
      {% endfor %}
      </pre>
      """
    When I run jekyll build --drafts
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "\"path\":\"_drafts/avengers-endgame/screencap-001.png\"" in "_site/index.html"
    And I should see "\"url\":\"/2019/03/27/screencap-001.png\"" in "_site/index.html"
    And I should see "\"path\":\"_drafts/star-wars/cover.jpg\"" in "_site/index.html"
    And I should see "\"url\":\"/2009/03/27/cover.jpg\"" in "_site/index.html"

  Scenario: Attachments of posts in a site with custom permalink style
    Given I have a configuration file with "permalink" set to "/:categories/:title.html"
    And I have a _posts directory
    And I have the following posts with attachments:
      | title            | date       | content                 | attachments          |
      | Star Wars        | 2009-03-27 | Luke, I am your father. | pic070.png,cover.jpg |
      | Avengers-Endgame | 2019-03-27 | I am inevitable!        |                      |
    And I have a movies directory
    And I have the following post with attachments inside movies directory:
      | title            | date       | content          | attachments          |
      | Avengers-Endgame | 2019-03-27 | I am inevitable! | pic120.png,cover.jpg |
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site/star-wars.html" file should exist
    And the "_site/avengers-endgame.html" file should exist
    And the "_site/2009/03/27/cover.jpg" file should exist
    And the "_site/movies/avengers-endgame.html" file should exist
    And the "_site/movies/2019/03/27/cover.jpg" file should exist
    But the "_site/cover.jpg" file should not exist
    And the "_site/movies/cover.jpg" file should not exist
