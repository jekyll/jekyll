Feature: Site data
  As a hacker who likes to blog
  I want to be able to embed data into my site
  In order to make the site slightly dynamic

  Scenario: Use page variable in a page
    Given I have a blank site
    And I have an "contact.html" file with title "Contact" that contains "{{ page.title }}: email@me.com"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Contact: email@me.com" in "_site/index.html"

  Scenario: Use site.time variable
    Given I have a blank site
    And I have an "index.html" file that contains "Generated on: {{ site.time }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Generated on: #{Date.today.strftime('%Y-%m-%d')}" in "_site/index.html"

  Scenario: Use site.posts variable for latest post
    Given I have a blank site
    And I have a _posts directory
    And I have an "index.html" file that contains "{{ site.posts.first.title }}: {{ site.posts.first.url }}"
    And I have a post titled "First Post" for "3/25/2009" that contains "First!"
    And I have a post titled "Second Post" for "3/26/2009" that contains "Second!"
    And I have a post titled "Third Post" for "3/27/2009" that contains "Third!"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Third Post: /2009/03/27/third-post.html" in "_site/index.html"

  Scenario: Use site.posts variable in a loop
    Given I have a blank site
    And I have a _posts directory
    And I have an "index.html" file that contains "{% for post in site.posts %} {{ post.title }} {% endfor %}"
    And I have a post titled "First Post" for "3/25/2009" that contains "First!"
    And I have a post titled "Second Post" for "3/26/2009" that contains "Second!"
    And I have a post titled "Third Post" for "3/27/2009" that contains "Third!"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Third Post Second Post First Post" in "_site/index.html"

  Scenario: Use site.categories.code variable
    Given I have a blank site
    And I have a _posts directory
    And I have an "index.html" file that contains "{% for post in site.categories.code %} {{ post.title }} {% endfor %}"
    And I have a post titled "Awesome Hack" for "3/26/2009" that contains "while(true) { puts 'infinity' }"
    And I have a post titled "Awesome Hack" for "3/26/2009" with category "code"
    And I have a post titled "Delicious Beer" for "3/26/2009" that contains "# Yuengling"
    And I have a post titled "Delicious Beer" for "3/26/2009" with category "food"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Awesome Hack" in "_site/index.html"
