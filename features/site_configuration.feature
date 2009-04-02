Feature: Site configuration
  As a hacker who likes to blog
  I want to be able to configure jekyll
  In order to make setting up a site easier

  Scenario: Change destination directory
    Given I have a blank site in "_sourcedir"
    And I have an "_sourcedir/index.html" file that contains "Changing source directory"
    And I have a configuration file with "source" set to "_sourcedir"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Changing source directory" in "_site/index.html"

  Scenario: Change destination directory
    Given I have an "index.html" file that contains "Changing destination directory"
    And I have a configuration file with "destination" set to "_mysite"
    When I run jekyll
    Then the _mysite directory should exist
    And I should see "Changing destination directory" in "_mysite/index.html"

  Scenario: Use RDiscount for markup
    Given I have an "index.markdown" page that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "rdiscount"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<a href="http://google.com">Google</a>" in "_site/index.html"

  Scenario: Use Maruku for markup
    Given I have an "index.markdown" page that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "maruku"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<a href='http://google.com'>Google</a>" in "_site/index.html"

  Scenario: Use none permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                 | date      | content          |
      | None Permalink Schema | 3/27/2009 | Totally nothing. |
    And I have a configuration file with "permalink" set to "none"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally nothing." in "_site/none-permalink-schema.html"

  Scenario: Use pretty permalink schema
    Given I have a _posts directory
    And I have the following post:
      | title                   | date      | content            |
      | Pretty Permalink Schema | 3/27/2009 | Totally wordpress. |
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Totally wordpress." in "_site/2009/03/27/pretty-permalink-schema/index.html"

  Scenario: Highlight code with pygments
    Given I have an "index.html" file that contains "{% highlight ruby %} puts 'Hello world!' {% endhighlight %}"
    And I have a configuration file with "pygments" set to "true"
    When I run jekyll
    Then the _site directory should exist
    And I should see "puts 'Hello world!'" in "_site/index.html"
