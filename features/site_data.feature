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
    And I should see "Generated on: #{Date.today.strftime("%Y-%m-%d")}" in "_site/index.html"

  Scenario: Use site.posts variable for first post
    Given I have a blank site
    And I have an "index.html" file that contains "{{ site.posts.first.title }}: {{ site.posts.first.url }}"
    And I have a post titled "First Post" for "3/25/2009" that contains "Whoa."
    And I have a post titled "Pretty Permalink Schema" for "3/25/2009" that contains "Whoa."
    And I have a post titled "Pretty Permalink Schema" for "3/25/2009" that contains "Whoa."
    When I run jekyll
    Then the _site directory should exist
    And I should see "Generated on: #{Date.today.strftime("%Y-%m-%d")}" in "_site/index.html"

  Scenario: Use site.categories variable
  Scenario: Use site.categories.life variable
  Scenario: Use site.related_posts variable
