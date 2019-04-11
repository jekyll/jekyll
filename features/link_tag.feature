Feature: Link Tag
  As a hacker who likes to write a variety of content
  I want to be able to link to pages and documents
  And render them without much hassle

  Scenario: Basic site with two pages
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Home]({% link index.md %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/about.html\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/\">Home</a></p>" in "_site/about.html"

  Scenario: Basic site with custom page-permalinks
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page with permalink "/about/" that contains "[Home]({% link index.md %})"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/about/\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/\">Home</a></p>" in "_site/about/index.html"

  Scenario: Basic site with custom site-wide-permalinks
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Home]({% link index.md %})"
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/about/\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/\">Home</a></p>" in "_site/about/index.html"

  Scenario: Basic site with two pages and custom baseurl
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Home]({% link index.md %})"
    And I have a configuration file with "baseurl" set to "/blog"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/blog/about.html\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/blog/\">Home</a></p>" in "_site/about.html"

  Scenario: Basic site with two pages and custom baseurl and permalinks
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Home]({% link index.md %})"
    And I have a "_config.yml" file with content:
    """
    baseurl: /blog
    permalink: pretty
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/blog/about/\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/blog/\">Home</a></p>" in "_site/about/index.html"

  Scenario: Linking to a ghost file
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Contact]({% link contact.md %})"
    When I run jekyll build
    Then I should get a non-zero exit status
    And the _site directory should not exist
    And I should see "Could not find document 'contact.md' in tag 'link'" in the build output

  Scenario: Complex site with a variety of files
    Given I have an "index.md" page that contains "[About my projects]({% link about.md %})"
    And I have an "about.md" page that contains "[Latest Hack]({% link _posts/2018-02-15-metaprogramming.md %})"
    And I have a _posts directory
    And I have an "_posts/2018-02-15-metaprogramming.md" page that contains "[Download This]({% link script.txt %})"
    And I have a "script.txt" file that contains "Static Alert!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p><a href=\"/about.html\">About my projects</a></p>" in "_site/index.html"
    And I should see "<p><a href=\"/2018/02/15/metaprogramming.html\">Latest Hack</a></p>" in "_site/about.html"
    And I should see "<p><a href=\"/script.txt\">Download This</a></p>" in "_site/2018/02/15/metaprogramming.html"
    And I should see "Static Alert!" in "_site/script.txt"
