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

  Scenario: Include a nested file relative to a post as an excerpt
    Given I have a _posts directory
    And I have a _posts/snippets directory
    And I have a _posts/snippets/welcome_para directory
    And I have a "_posts/2018-09-02-star-wars.md" file with content:
      """
      {% include_relative snippets/welcome_para.md %}

      Hello World
      """
    And I have an "_posts/snippets/welcome_para.md" file that contains "{% include_relative snippets/welcome_para/greeting.md %} Dear Reader!"
    And I have an "_posts/snippets/welcome_para/greeting.md" file that contains "Welcome back"
    And I have an "index.md" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Welcome back Dear Reader!" in "_site/2018/09/02/star-wars.html"
    And I should see "Welcome back Dear Reader!" in "_site/index.html"

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

  Scenario: Include multiple files relative to a page at root
    Given I have an "apple.md" page with foo "bar" that contains "{{ page.path }}, {{ page.foo }}"
    And I have an "banana.md" page with content:
      """
        {% include_relative apple.md %}
        {% include_relative cherry.md %}

        {{ page.path }}
      """
    And I have an "cherry.md" page with foo "lipsum" that contains "{{ page.path }}, {{ page.foo }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p>apple.md, bar</p>" in "_site/apple.html"
    And I should see "<hr />\n<p>foo: bar" in "_site/banana.html"
    And I should see "<hr />\n<p>foo: lipsum" in "_site/banana.html"
    And I should see "<p>cherry.md, lipsum</p>" in "_site/cherry.html"
    But I should not see "foo: lipsum" in "_site/cherry.html"
