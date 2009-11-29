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

  Scenario: Exclude files inline
    Given I have an "Rakefile" file that contains "I want to be excluded"
    And I have an "README" file that contains "I want to be excluded"
    And I have an "index.html" file that contains "I want to be included"
    And I have a configuration file with "exclude" set to "Rakefile", "README"
    When I run jekyll
    Then I should see "I want to be included" in "_site/index.html"
    And the "_site/Rakefile" file should not exist
    And the "_site/README" file should not exist

  Scenario: Exclude files with YAML array
    Given I have an "Rakefile" file that contains "I want to be excluded"
    And I have an "README" file that contains "I want to be excluded"
    And I have an "index.html" file that contains "I want to be included"
    And I have a configuration file with "exclude" set to:
      | Value    |
      | README   |
      | Rakefile |
    When I run jekyll
    Then I should see "I want to be included" in "_site/index.html"
    And the "_site/Rakefile" file should not exist
    And the "_site/README" file should not exist

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

  Scenario: Highlight code with pygments
    Given I have an "index.html" file that contains "{% highlight ruby %} puts 'Hello world!' {% endhighlight %}"
    And I have a configuration file with "pygments" set to "true"
    When I run jekyll
    Then the _site directory should exist
    And I should see "puts 'Hello world!'" in "_site/index.html"

  Scenario: Load an extension from _lib
    Given I have an "index.html" page that contains "{{ 'extension' | hello }}"
    And I have a _lib directory
    And I have a "_lib/hello.rb" file that contains "module Jekyll::Filters ; def hello(input) ; "hello #{input}" ; end ; end"
    And I have a configuration file with "extensions" set to "true"
    When I run jekyll
    Then the _site directory should exist
    And I should see "hello extension" in "_site/index.html"

  Scenario: Skip loading extensions from _lib
    Given I have an "index.html" page that contains "{{ 'extension' | hello }}"
    And I have a _lib directory
    And I have a "_lib/hello.rb" file that contains "module Jekyll::Filters ; def hello(input) ; "hello #{input}" ; end ; end"
    And I have a configuration file with "extensions" set to "false"
    When I run jekyll
    Then the _site directory should exist
    And I should not see "hello extension" in "_site/index.html"
