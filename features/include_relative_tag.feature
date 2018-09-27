Feature: include_relative Tag
  In order to share content across several closely related pages
  As a hacker who likes to blog
  I want to be able to include snippets in my site's pages and documents relative to current file

  Scenario: Include a file relative to a post
    Given I have a _posts directory
    And I have a _posts/snippets directory
    And I have the following post:
      | title     | date       | content                                         |
      | Star Wars | 2018-09-02 | {% include_relative snippets/welcome_para.md %} |
    And I have an "_posts/snippets/welcome_para.md" file that contains "Welcome back Dear Reader!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Welcome back Dear Reader!" in "_site/2018/09/02/star-wars.html"

  Scenario: Include a nested file relative to a post
    Given I have a _posts directory
    And I have a _posts/snippets directory
    And I have a _posts/snippets/welcome_para directory
    And I have the following post:
      | title     | date       | content                                         |
      | Star Wars | 2018-09-02 | {% include_relative snippets/welcome_para.md %} |
    And I have an "_posts/snippets/welcome_para.md" file that contains "{% include_relative snippets/welcome_para/greeting.md %} Dear Reader!"
    And I have an "_posts/snippets/welcome_para/greeting.md" file that contains "Welcome back"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Welcome back Dear Reader!" in "_site/2018/09/02/star-wars.html"

  Scenario: Include a nested file relative to a page at root
    Given I have a snippets directory
    And I have a snippets/welcome_para directory
    And I have a "index.md" page that contains "{% include_relative snippets/welcome_para.md %}"
    And I have a "snippets/welcome_para.md" file that contains "{% include_relative snippets/welcome_para/greeting.md %} Dear Reader!"
    And I have a "snippets/welcome_para/greeting.md" file that contains "Welcome back"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Welcome back Dear Reader!" in "_site/index.html"
