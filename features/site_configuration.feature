Feature: Site configuration
  As a hacker who likes to blog
  I want to be able to configure jekyll
  In order to make setting up a site easier

  Scenario: Change destination directory
    Given I have a blank site in "_sourcedir"
    And I have an "index.html" file that contains "Changing source directory"
    And I have a configuration file in "_sourcedir" with "source" set to "_sourcedir"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Changing source directory" in "_site/index.html"

  Scenario: Change destination directory
    Given I have a blank site
    And I have an "index.html" file that contains "Changing destination directory"
    And I have a configuration file with "site" set to "_mysite"
    When I run jekyll
    Then the _mysite directory should exist
    And I should see "Basic Site" in "_mysite/index.html"

  Scenario: Use RDiscount for markup
    Given I have a blank site
    And I have an "index.html" file that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "rdiscount"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<a href='http://google.com/>Google</a>" in "_site/index.html"

  Scenario: Use Maruku for markup
    Given I have a blank site
    And I have an "index.html" file that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "rdiscount"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<a href='http://google.com/>Google</a>" in "_site/index.html"

  Scenario: Disable auto-regeneration
    Given I have a blank site
    And I have an "index.html" file that contains "My Awesome Site"
    And I have a configuration file with "auto" set to "false"
    When I run jekyll
    And I change "index.html" to contain "Auto-regenerate off!"
    Then the _site directory should exist
    And I should see "My awesome site" in "_site/index.html"

  Scenario: Run server to host generated site
    Given I have a blank site
    And I have an "index.html" file that contains "WEBrick to the rescue"
    And I have a configuration file with "server" set to "true"
    When I run jekyll
    And I go to "http://0.0.0.0:4000"
    Then I should see "WEBrick to the rescue"

  Scenario: Run server on a different server port
    Given I have a blank site
    And I have an "index.html" file that contains "Changing Port"
    And I have a configuration file with "server" set to "true"
    And I have a configuration file with "port" set to "1337"
    When I run jekyll
    And I go to "http://0.0.0.0:1337"
    Then I should see "Changing Port"

  Scenario: Use none permalink schema
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "None Permalink Schema" for "3/25/2009" that contains "Whoa."
    And I have a configuration file with "permalink" set to "none"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Whoa." in "_site/none-permalink-schema.html"

  Scenario: Use pretty permalink schema
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Pretty Permalink Schema" for "3/25/2009" that contains "Whoa."
    And I have a configuration file with "permalink" set to "pretty"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Whoa." in "_site/2009/03/25/pretty-permalink-schema/index.html"

  Scenario: Highlight code with pygments
    Given I have a blank site
    And I have an "index.html" file that contains "{% highlight ruby %} puts 'Hello world!' {% endhighlight %}"
    And I have a configuration file with "pygments" set to "true"
    When I run jekyll
    Then the _site directory should exist
    And I should see "puts 'Hello world!'" in "_site/index.html"
