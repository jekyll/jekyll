Feature: Yaml collections
  As a developer who likes to structured data
  I want to be able to create collections of data sets
  And render them

  Scenario: Unrendered collection
    Given I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    And I have a configuration file with "collections" set to "['movies']"
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site/movies/the-breakfast-club.html" file should not exist

  Scenario: Specifically unrendered collection
    Given I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: false
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the "_site/movies/the-breakfast-club.html" file should not exist

  Scenario: Rendered collection
    Given I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: true
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site/movies directory should exist
    And the "_site/movies/the-breakfast-club.html" file should exist

  Scenario: Access unrendered collection via liquid
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }} site.movies.first.title => '{{ site.movies.first.title }}'"
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: false
    """
    And I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "site.movies.first.title => 'The Breakfast Club'" in "_site/index.html"
    And the "_site/movies/the-breakfast-club.html" file should not exist

  Scenario: Access rendered collection via liquid
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }} site.movies.first.title => '{{ site.movies.first.title }}'"
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: true
    """
    And I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "site.movies.first.title => 'The Breakfast Club'" in "_site/index.html"
    And the "_site/movies/the-breakfast-club.html" file should exist

  Scenario: Rendered yaml document with no \`content\` data
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }}"
    And I have a default layout that contains "<div class='title'>{{page.title}}</div> {{content}}"
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: true
    defaults:
      - scope:
          type: movies
        values:
          layout: default
    """
    And I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    |
    | The Breakfast Club | John Hughes |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Collections: output => true" in "_site/index.html"
    And I should see "label => movies" in "_site/index.html"
    And I should see "<div class='title'>The Breakfast Club</div>" in "_site/movies/the-breakfast-club.html"
    And I should not see "John Hughes" in "_site/movies/the-breakfast-club.html"

  Scenario: Rendered yaml document with \`content\` data
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }}"
    And I have a default layout that contains "<div class='title'>{{page.title}}</div> {{content}}"
    And I have a "_config.yml" file with content:
    """
    collections:
      movies:
        output: true
    defaults:
      - scope:
          type: movies
        values:
          layout: default
    """
    And I have a _movies directory
    And I have the following yaml document under the movies collection:
    | title              | director    | content             |
    | The Breakfast Club | John Hughes | {{ page.director }} |
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "Collections: output => true" in "_site/index.html"
    And I should see "label => movies" in "_site/index.html"
    And I should see "<div class='title'>The Breakfast Club</div>" in "_site/movies/the-breakfast-club.html"
    And I should see "John Hughes" in "_site/movies/the-breakfast-club.html"
