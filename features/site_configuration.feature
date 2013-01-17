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
    And I have a configuration file with "exclude" set to "['Rakefile', 'README']"
    When I run jekyll
    Then I should see "I want to be included" in "_site/index.html"
    And the "_site/Rakefile" file should not exist
    And the "_site/README" file should not exist

  Scenario: Exclude files with YAML array
    Given I have an "Rakefile" file that contains "I want to be excluded"
    And I have an "README" file that contains "I want to be excluded"
    And I have an "index.html" file that contains "I want to be included"
    And I have a configuration file with "exclude" set to:
      | value    |
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

  Scenario: Use Kramdown for markup
    Given I have an "index.markdown" page that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "kramdown"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<a href="http://google.com">Google</a>" in "_site/index.html"

  Scenario: Use Redcarpet for markup
    Given I have an "index.markdown" page that contains "[Google](http://google.com)"
    And I have a configuration file with "markdown" set to "redcarpet"
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

  Scenario: Set time and no future dated posts
    Given I have a _layouts directory
    And I have a page layout that contains "Page Layout: {{ site.posts.size }} on {{ site.time | date: "%Y-%m-%d" }}"
    And I have a post layout that contains "Post Layout: {{ content }}"
    And I have an "index.html" page with layout "page" that contains "site index page"
    And I have a configuration file with:
      | key         | value        |
      | time        | 2010-01-01   |
      | future      | false        |
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | entry1    | 12/31/2007 | post    | content for entry1.                    |
      | entry2    | 01/31/2020 | post    | content for entry2.                    |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Page Layout: 1 on 2010-01-01" in "_site/index.html"
    And I should see "Post Layout: <p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And the "_site/2020/01/31/entry2.html" file should not exist

  Scenario: Set time and future dated posts allowed
    Given I have a _layouts directory
    And I have a page layout that contains "Page Layout: {{ site.posts.size }} on {{ site.time | date: "%Y-%m-%d" }}"
    And I have a post layout that contains "Post Layout: {{ content }}"
    And I have an "index.html" page with layout "page" that contains "site index page"
    And I have a configuration file with:
      | key         | value        |
      | time        | 2010-01-01   |
      | future      | true         |
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | entry1    | 12/31/2007 | post    | content for entry1.                    |
      | entry2    | 01/31/2020 | post    | content for entry2.                    |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Page Layout: 2 on 2010-01-01" in "_site/index.html"
    And I should see "Post Layout: <p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see "Post Layout: <p>content for entry2.</p>" in "_site/2020/01/31/entry2.html"

  Scenario: Limit the number of posts generated by most recent date
    Given I have a _posts directory
    And I have a configuration file with:
      | key         | value       |
      | limit_posts | 2           |
    And I have the following posts:
      | title   | date      | content          |
      | Apples  | 3/27/2009 | An article about apples |
      | Oranges | 4/1/2009  | An article about oranges |
      | Bananas | 4/5/2009  | An article about bananas |
    When I run jekyll
    Then the _site directory should exist
    And the "_site/2009/04/05/bananas.html" file should exist
    And the "_site/2009/04/01/oranges.html" file should exist
    And the "_site/2009/03/27/apples.html" file should not exist

  Scenario: Copy over normally excluded files when they are explicitly included
    Given I have a ".gitignore" file that contains ".DS_Store"
    And I have an ".htaccess" file that contains "SomeDirective"
    And I have a configuration file with "include" set to:
      | value      |
      | .gitignore |
      | .foo       |
    When I run jekyll
    Then the _site directory should exist
    And I should see ".DS_Store" in "_site/.gitignore"
    And the "_site/.htaccess" file should not exist

  Scenario: Using a different layouts directory
    Given I have a _theme directory
    And I have a page theme that contains "Page Layout: {{ site.posts.size }} on {{ site.time | date: "%Y-%m-%d" }}"
    And I have a post theme that contains "Post Layout: {{ content }}"
    And I have an "index.html" page with layout "page" that contains "site index page"
    And I have a configuration file with:
      | key         | value        |
      | time        | 2010-01-01   |
      | future      | true         |
      | layouts     | _theme       |
    And I have a _posts directory
    And I have the following posts:
      | title     | date       | layout  | content                                |
      | entry1    | 12/31/2007 | post    | content for entry1.                    |
      | entry2    | 01/31/2020 | post    | content for entry2.                    |
    When I run jekyll
    Then the _site directory should exist
    And I should see "Page Layout: 2 on 2010-01-01" in "_site/index.html"
    And I should see "Post Layout: <p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see "Post Layout: <p>content for entry2.</p>" in "_site/2020/01/31/entry2.html"
