Feature: Site data
  As a hacker who likes to blog
  I want to be able to embed data into my site
  In order to make the site slightly dynamic

  Scenario: Use page variable in a page
    Given I have an "contact.html" page with title "Contact" that contains "{{ page.title }}: email@example.com"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Contact: email@example.com" in "_site/contact.html"

  Scenario Outline: Use page.path variable in a page
    Given I have a <dir> directory
    And I have a "<path>" page that contains "Source path: {{ page.path }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Source path: <path>" in "_site/<path>"

    Examples:
      | dir        | path                 |
      | .          | index.html           |
      | dir        | dir/about.html       |
      | dir/nested | dir/nested/page.html |

  Scenario: Override page.path
    Given I have an "override.html" page with path "custom-override.html" that contains "Custom path: {{ page.path }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Custom path: custom-override.html" in "_site/override.html"

  Scenario: Use site.time variable
    Given I have an "index.html" page that contains "{{ site.time }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see today's time in "_site/index.html"

  Scenario: Use site.posts variable for latest post
    Given I have a _posts directory
    And I have an "index.html" page that contains "{{ site.posts.first.title }}: {{ site.posts.first.url }}"
    And I have the following posts:
      | title       | date       | content        |
      | First Post  | 2009-03-25 | My First Post  |
      | Second Post | 2009-03-26 | My Second Post |
      | Third Post  | 2009-03-27 | My Third Post  |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Third Post: /2009/03/27/third-post.html" in "_site/index.html"

  Scenario: Use site.posts variable in a loop
    Given I have a _posts directory
    And I have an "index.html" page that contains "{% for post in site.posts %} {{ post.title }} {% endfor %}"
    And I have the following posts:
      | title       | date       | content        |
      | First Post  | 2009-03-25 | My First Post  |
      | Second Post | 2009-03-26 | My Second Post |
      | Third Post  | 2009-03-27 | My Third Post  |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Third Post  Second Post  First Post" in "_site/index.html"

  Scenario: Use site.categories.code variable
    Given I have a _posts directory
    And I have an "index.html" page that contains "{% for post in site.categories.code %} {{ post.title }} {% endfor %}"
    And I have the following posts:
      | title          | date       | category | content            |
      | Awesome Hack   | 2009-03-26 | code     | puts 'Hello World' |
      | Delicious Beer | 2009-03-26 | food     | 1) Yuengling       |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Awesome Hack" in "_site/index.html"

  Scenario: Use site.tags variable
    Given I have a _posts directory
    And I have an "index.html" page that contains "{% for post in site.tags.beer %} {{ post.content }} {% endfor %}"
    And I have the following posts:
      | title          | date       | tag  | content      |
      | Delicious Beer | 2009-03-26 | beer | 1) Yuengling |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Yuengling" in "_site/index.html"

  Scenario: Order Posts by name when on the same date
  Given I have a _posts directory
  And I have an "index.html" page that contains "{% for post in site.posts %}{{ post.title }}:{{ post.previous.title}},{{ post.next.title}} {% endfor %}"
  And I have the following posts:
    | title | date       | content |
    | first | 2009-02-26 | first   |
    | A     | 2009-03-26 | A       |
    | B     | 2009-03-26 | B       |
    | C     | 2009-03-26 | C       |
    | last  | 2009-04-26 | last    |
  When I run jekyll build
  Then the _site directory should exist
  And I should see "last:C, C:B,last B:A,C A:first,B first:,A" in "_site/index.html"

  Scenario: Use configuration date in site payload
    Given I have an "index.html" page that contains "{{ site.url }}"
    And I have a configuration file with "url" set to "http://example.com"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "http://example.com" in "_site/index.html"

  Scenario: Access Jekyll version via jekyll.version
    Given I have an "index.html" page that contains "{{ jekyll.version }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "\d+\.\d+\.\d+" in "_site/index.html"
