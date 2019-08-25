Feature: Site configuration
  As a hacker who likes to blog
  I want to be able to configure jekyll
  In order to make setting up a site easier

  Scenario: Change source directory
    Given I have a blank site in "_sourcedir"
    And I have an "_sourcedir/index.html" file that contains "Changing source directory"
    And I have a configuration file with "source" set to "_sourcedir"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Changing source directory" in "_site/index.html"

  Scenario: Change destination directory
    Given I have an "index.html" file that contains "Changing destination directory"
    And I have a configuration file with "destination" set to "_mysite"
    When I run jekyll build
    Then the _mysite directory should exist
    And I should see "Changing destination directory" in "_mysite/index.html"

  Scenario Outline: Similarly named source and destination
    Given I have a blank site in "<source>"
    And I have an "<source>/index.md" page that contains "markdown"
    And I have a configuration file with:
    | key         | value    |
    | source      | <source> |
    | destination | <dest>   |
    When I run jekyll build
    Then the <source> directory should exist
    And the "<dest>/index.html" file should <file_exist> exist
    And I should see "markdown" in "<source>/index.md"

    Examples:
      | source        | dest        | file_exist |
      | mysite_source | mysite      |            |
      | mysite        | mysite_dest |            |
      | mysite/       | mysite      | not        |
      | mysite        | ./mysite    | not        |
      | mysite/source | mysite      | not        |
      | mysite        | mysite/dest |            |

  Scenario: Exclude files inline
    Given I have an "Rakefile" file that contains "I want to be excluded"
    And I have an "README" file that contains "I want to be excluded"
    And I have an "index.html" file that contains "I want to be included"
    And I have a "Gemfile" file that contains "gem 'include-me'"
    And I have a configuration file with "exclude" set to "['Rakefile', 'README']"
    When I run jekyll build
    Then I should see "I want to be included" in "_site/index.html"
    And the "_site/Gemfile" file should not exist
    And the "_site/Rakefile" file should not exist
    And the "_site/README" file should not exist

  Scenario: Exclude files with YAML array
    Given I have an "Rakefile" file that contains "I want to be excluded"
    And I have an "README" file that contains "I want to be excluded"
    And I have an "index.html" file that contains "I want to be included"
    And I have a "Gemfile" file that contains "gem 'include-me'"
    And I have a configuration file with "exclude" set to:
      | value    |
      | README   |
      | Rakefile |
    When I run jekyll build
    Then I should see "I want to be included" in "_site/index.html"
    And the "_site/Rakefile" file should not exist
    And the "_site/README" file should not exist
    And the "_site/Gemfile" file should not exist

  Scenario: Copy over excluded files when their directory is explicitly included
    Given I have a ".gitignore" file that contains ".DS_Store"
    And I have an ".htaccess" file that contains "SomeDirective"
    And I have a "Gemfile" file that contains "gem 'include-me'"
    And I have a node_modules directory
    And I have a "node_modules/bazinga.js" file that contains "var c = 'Bazinga!';"
    And I have a "node_modules/warning.js" file that contains "var w = 'Winter is coming!';"
    And I have a configuration file with "include" set to:
      | value        |
      | .gitignore   |
      | .foo         |
      | Gemfile      |
      | node_modules |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/.htaccess" file should not exist
    But I should see ".DS_Store" in "_site/.gitignore"
    And I should see "gem 'include-me'" in "_site/Gemfile"
    And I should see "var c = 'Bazinga!';" in "_site/node_modules/bazinga.js"
    And I should see "var w = 'Winter is coming!';" in "_site/node_modules/warning.js"

  Scenario: Copy over excluded files only when they are explicitly included
    Given I have a ".gitignore" file that contains ".DS_Store"
    And I have an ".htaccess" file that contains "SomeDirective"
    And I have a node_modules directory
    And I have a "node_modules/bazinga.js" file that contains "var c = 'Bazinga!';"
    And I have a "node_modules/warning.js" file that contains "var w = 'Winter is coming!';"
    And I have a configuration file with "include" set to:
      | value                   |
      | .gitignore              |
      | .foo                    |
      | node_modules/bazinga.js |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/.htaccess" file should not exist
    But I should see ".DS_Store" in "_site/.gitignore"
    And I should see "var c = 'Bazinga!';" in "_site/node_modules/bazinga.js"
    But the "_site/node_modules/warning.js" file should not exist

  Scenario: Copy over excluded wild-card files only when they are explicitly included
    Given I have a ".gitignore" file that contains ".DS_Store"
    And I have an ".htaccess" file that contains "SomeDirective"
    And I have an "foo.txt" file that contains "Lorem Ipsum"
    And I have an "index.md" page that contains "{{ site.title }}"
    And I have an "about.md" page that contains "{{ site.author }}"
    And I have a configuration file with:
      | key      | value        |
      | title    | Barren Site  |
      | author   | John Doe     |
      | exclude  | ["**"]       |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/.gitignore" file should not exist
    And the "_site/foo.txt" file should not exist
    And the "_site/index.html" file should not exist
    And the "_site/about.html" file should not exist
    But the "_site/.htaccess" file should exist
    Given I have a configuration file with:
      | key      | value        |
      | title    | Barren Site  |
      | author   | John Doe     |
      | exclude  | ["**"]       |
      | include  | ["about.md"] |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/.gitignore" file should not exist
    And the "_site/foo.txt" file should not exist
    And the "_site/index.html" file should not exist
    And the "_site/.htaccess" file should not exist
    But the "_site/about.html" file should exist
    And I should see "John Doe" in "_site/about.html"

  Scenario: Use Kramdown for markup
    Given I have an "index.markdown" page that contains "[Google](https://www.google.com)"
    And I have a configuration file with "markdown" set to "kramdown"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<a href=\"https://www.google.com\">Google</a>" in "_site/index.html"

  Scenario: Highlight code with rouge
    Given I have an "index.html" page that contains "{% highlight ruby %} puts 'Hello world!' {% endhighlight %}"
    And I have a configuration file with "highlighter" set to "rouge"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hello world!" in "_site/index.html"
    And I should see "class=\"highlight\"" in "_site/index.html"

  Scenario: Rouge renders code block once
    Given I have a configuration file with "highlighter" set to "rouge"
    And I have a _posts directory
    And I have the following post:
      | title | date             | layout  | content                                      |
      | foo   | 2014-04-27 11:34 | default | {% highlight text %} test {% endhighlight %} |
    When I run jekyll build
    Then I should not see "highlight(.*)highlight" in "_site/2014/04/27/foo.html"

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
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
      | entry2 | 2020-01-31 | post   | content for entry2. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
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
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
      | entry2 | 2020-01-31 | post   | content for entry2. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Page Layout: 2 on 2010-01-01" in "_site/index.html"
    And I should see "Post Layout: <p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see "Post Layout: <p>content for entry2.</p>" in "_site/2020/01/31/entry2.html"

    Scenario: Generate proper dates with explicitly set timezone (same as posts' time)
      Given I have a _layouts directory
      And I have a page layout that contains "Page Layout: {{ site.posts.size }}"
      And I have a post layout that contains "Post Layout: {{ content }} built at {{ page.date | date_to_xmlschema }}"
      And I have an "index.html" page with layout "page" that contains "site index page"
      And I have a configuration file with:
        | key         | value            |
        | timezone    | America/New_York |
      And I have a _posts directory
      And I have the following posts:
        | title     | date                   | layout  | content             |
        | entry1    | 2013-04-09 23:22 -0400 | post    | content for entry1. |
        | entry2    | 2013-04-10 03:14 -0400 | post    | content for entry2. |
      When I run jekyll build
      Then I should get a zero exit status
      And the _site directory should exist
      And I should see "Page Layout: 2" in "_site/index.html"
      And I should see "Post Layout: <p>content for entry1.</p>\n built at" in "_site/2013/04/09/entry1.html"
      And I should see "Post Layout: <p>content for entry2.</p>\n built at" in "_site/2013/04/10/entry2.html"
      And I should see date "2013-04-09T23:22:00-04:00" in "_site/2013/04/09/entry1.html" unless Windows
      And I should see date "2013-04-09T22:22:00-05:00" in "_site/2013/04/09/entry1.html" if on Windows
      And I should see date "2013-04-10T03:14:00-04:00" in "_site/2013/04/10/entry2.html" unless Windows
      And I should see date "2013-04-10T02:14:00-05:00" in "_site/2013/04/10/entry2.html" if on Windows

    Scenario: Generate proper dates with explicitly set timezone (different than posts' time)
      Given I have a _layouts directory
      And I have a page layout that contains "Page Layout: {{ site.posts.size }}"
      And I have a post layout that contains "Post Layout: {{ content }} built at {{ page.date | date_to_xmlschema }}"
      And I have an "index.html" page with layout "page" that contains "site index page"
      And I have a configuration file with:
        | key         | value                |
        | timezone    | Pacific/Honolulu     |
      And I have a _posts directory
      And I have the following posts:
        | title     | date                   | layout  | content             |
        | entry1    | 2013-04-09 23:22 +0400 | post    | content for entry1. |
        | entry2    | 2013-04-10 03:14 +0400 | post    | content for entry2. |
      When I run jekyll build
      Then I should get a zero exit status
    And the _site directory should exist
      And I should see "Page Layout: 2" in "_site/index.html"
      And the "_site/2013/04/09/entry1.html" file should exist
      And the "_site/2013/04/09/entry2.html" file should exist
      And I should see "Post Layout: <p>content for entry1.</p>\n built at 2013-04-09T09:22:00-10:00" in "_site/2013/04/09/entry1.html"
      And I should see "Post Layout: <p>content for entry2.</p>\n built at 2013-04-09T13:14:00-10:00" in "_site/2013/04/09/entry2.html"

  Scenario: Limit the number of posts generated by most recent date
    Given I have a _posts directory
    And I have a configuration file with:
      | key         | value       |
      | limit_posts | 2           |
    And I have the following posts:
      | title   | date       | content                  |
      | Apples  | 2009-03-27 | An article about apples  |
      | Oranges | 2009-04-01 | An article about oranges |
      | Bananas | 2009-04-05 | An article about bananas |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/2009/04/05/bananas.html" file should exist
    And the "_site/2009/04/01/oranges.html" file should exist
    And the "_site/2009/03/27/apples.html" file should not exist

  Scenario: Using a different layouts directory
    Given I have a _theme directory
    And I have a page theme that contains "Page Layout: {{ site.posts.size }} on {{ site.time | date: "%Y-%m-%d" }}"
    And I have a post theme that contains "Post Layout: {{ content }}"
    And I have an "index.html" page with layout "page" that contains "site index page"
    And I have a configuration file with:
      | key         | value        |
      | time        | 2010-01-01   |
      | future      | true         |
      | layouts_dir | _theme       |
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
      | entry2 | 2020-01-31 | post   | content for entry2. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Page Layout: 2 on 2010-01-01" in "_site/index.html"
    And I should see "Post Layout: <p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see "Post Layout: <p>content for entry2.</p>" in "_site/2020/01/31/entry2.html"

  Scenario: arbitrary file reads via layouts
    Given I have an "index.html" page with layout "page" that contains "FOO"
    And I have a "_config.yml" file that contains "layouts: '../../../../../../../../../../../../../../usr/include'"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "FOO" in "_site/index.html"
    And I should not see " " in "_site/index.html"
