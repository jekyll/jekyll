Feature: Create sites
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs

  Scenario: Blank site
    Given I do not have a "test_blank" directory
    When I run jekyll new test_blank --blank
    Then the test_blank/_layouts directory should exist
    And the test_blank/_posts directory should exist
    And the "test_blank/index.html" file should exist

  Scenario: Basic site
    Given I have an "index.html" file that contains "Basic Site"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Basic Site" in "_site/index.html"

  Scenario: Basic site with a post
    Given I have a _posts directory
    And I have the following post:
      | title   | date       | content          |
      | Hackers | 2009-03-27 | My First Exploit |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "My First Exploit" in "_site/2009/03/27/hackers.html"

  Scenario: Basic site with layout and a page
    Given I have a _layouts directory
    And I have an "index.html" page with layout "default" that contains "Basic Site with Layout"
    And I have a default layout that contains "Page Layout: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Page Layout: Basic Site with Layout" in "_site/index.html"

  Scenario: Basic site with layout and a post
    Given I have a _layouts directory
    And I have a _posts directory
    And I have the following posts:
      | title    | date       | layout  | content                               |
      | Wargames | 2009-03-27 | default | The only winning move is not to play. |
    And I have a default layout that contains "Post Layout: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post Layout: <p>The only winning move is not to play.</p>" in "_site/2009/03/27/wargames.html"

  Scenario: Basic site with layout inside a subfolder and a post
    Given I have a _layouts directory
    And I have a _posts directory
    And I have the following posts:
      | title    | date       | layout      | content                               |
      | Wargames | 2009-03-27 | post/simple | The only winning move is not to play. |
    And I have a post/simple layout that contains "Post Layout: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post Layout: <p>The only winning move is not to play.</p>" in "_site/2009/03/27/wargames.html"

  Scenario: Basic site with layouts, pages, posts and files
    Given I have a _layouts directory
    And I have a page layout that contains "Page {{ page.title }}: {{ content }}"
    And I have a post layout that contains "Post {{ page.title }}: {{ content }}"
    And I have an "index.html" page with layout "page" that contains "Site contains {{ site.pages.size }} pages and {{ site.posts.size }} posts"
    And I have a blog directory
    And I have a "blog/index.html" page with layout "page" that contains "blog category index page"
    And I have an "about.html" file that contains "No replacement {{ site.posts.size }}"
    And I have an "another_file" file that contains ""
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2009-03-27 | post   | content for entry1. |
      | entry2 | 2009-04-27 | post   | content for entry2. |
    And I have a category/_posts directory
    And I have the following posts in "category":
      | title  | date       | layout | content             |
      | entry3 | 2009-05-27 | post   | content for entry3. |
      | entry4 | 2009-06-27 | post   | content for entry4. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Page : Site contains 2 pages and 4 posts" in "_site/index.html"
    And I should see "No replacement \{\{ site.posts.size \}\}" in "_site/about.html"
    And I should see "" in "_site/another_file"
    And I should see "Page : blog category index page" in "_site/blog/index.html"
    And I should see "Post entry1: <p>content for entry1.</p>" in "_site/2009/03/27/entry1.html"
    And I should see "Post entry2: <p>content for entry2.</p>" in "_site/2009/04/27/entry2.html"
    And I should see "Post entry3: <p>content for entry3.</p>" in "_site/category/2009/05/27/entry3.html"
    And I should see "Post entry4: <p>content for entry4.</p>" in "_site/category/2009/06/27/entry4.html"

  Scenario: Basic site with include tag
    Given I have a _includes directory
    And I have an "index.html" page that contains "Basic Site with include tag: {% include about.textile %}"
    And I have an "_includes/about.textile" file that contains "Generated by Jekyll"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Basic Site with include tag: Generated by Jekyll" in "_site/index.html"

  Scenario: Basic site with subdir include tag
    Given I have a _includes directory
    And I have an "_includes/about.textile" file that contains "Generated by Jekyll"
    And I have an info directory
    And I have an "info/index.html" page that contains "Basic Site with subdir include tag: {% include about.textile %}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Basic Site with subdir include tag: Generated by Jekyll" in "_site/info/index.html"

  Scenario: Basic site with nested include tag
    Given I have a _includes directory
    And I have an "_includes/about.textile" file that contains "Generated by {% include jekyll.textile %}"
    And I have an "_includes/jekyll.textile" file that contains "Jekyll"
    And I have an "index.html" page that contains "Basic Site with include tag: {% include about.textile %}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Basic Site with include tag: Generated by Jekyll" in "_site/index.html"

  Scenario: Basic site with internal post linking
    Given I have an "index.html" page that contains "URL: {% post_url 2008-01-01-entry2 %}"
    And I have a configuration file with "permalink" set to "pretty"
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
      | entry2 | 2008-01-01 | post   | content for entry2. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "URL: /2008/01/01/entry2/" in "_site/index.html"

  Scenario: Basic site with whitelisted dotfile
    Given I have an ".htaccess" file that contains "SomeDirective"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "SomeDirective" in "_site/.htaccess"

  Scenario: File was replaced by a directory
    Given I have a "test" file that contains "some stuff"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    When I delete the file "test"
    Given I have a test directory
    And I have a "test/index.html" file that contains "some other stuff"
    When I run jekyll build
    Then the _site/test directory should exist
    And I should see "some other stuff" in "_site/test/index.html"

  Scenario: Basic site with unpublished page
    Given I have an "index.html" page with title "index" that contains "Published page"
    And I have a "public.html" page with published "true" that contains "Explicitly published page"
    And I have a "secret.html" page with published "false" that contains "Unpublished page"

    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/index.html" file should exist
    And the "_site/public.html" file should exist
    But the "_site/secret.html" file should not exist

    When I run jekyll build --unpublished
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/index.html" file should exist
    And the "_site/public.html" file should exist
    And the "_site/secret.html" file should exist

  Scenario: Basic site with page with future date
    Given I have a _posts directory
    And I have the following post:
      | title  | date       | layout | content             |
      | entry1 | 2020-12-31 | post   | content for entry1. |
      | entry2 | 2007-12-31 | post   | content for entry2. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "content for entry2" in "_site/2007/12/31/entry2.html"
    And the "_site/2020/12/31/entry1.html" file should not exist
    When I run jekyll build --future
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/2020/12/31/entry1.html" file should exist
