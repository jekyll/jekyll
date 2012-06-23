Feature: Directory 
  As a photographer who likes to hack
  I want to be able to make image galleries
  In order to share my awesome photos with the interwebs

  Scenario: Images stored in the source dir, default excludes .html files
    Given I have a "2011-03-10-foo.jpg" file that contains " "
    And I have a "2011-03-11-bar.jpg" file that contains " "
    And I have an "index.html" page that contains "{% directory exclude: '.html$' %}{{ file.url }} {% enddirectory %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "/2011-03-10-foo.jpg /2011-03-11-bar.jpg" in "_site/index.html"

  Scenario: Images in a nested directories
    Given I have a images/vacation/naughty directory
    And I have an "images/vacation/naughty/2011-03-10-foo.jpg" file that contains " "
    And I have an "images/vacation/naughty/2011-03-11-bar.jpg" file that contains " "
    And I have an "index.html" page that contains "{% directory path: images/vacation/naughty %}{{ file.url }} {% enddirectory %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "/images/vacation/naughty/2011-03-10-foo.jpg /images/vacation/naughty/2011-03-11-bar.jpg" in "_site/index.html"

  Scenario: I want to show a list of files to download instead of images
    Given I have a downloads/files directory
    And I have a "downloads/files/example-0.1.1.tar.gz" file that contains " "
    And I have a "downloads/files/example-0.2.0.tar.gz" file that contains " "
    And I have a "downloads/index.html" page that contains "{% directory path: downloads/files reverse: true %}{{ file.slug }} {% enddirectory %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "example-0.2.0.tar example-0.1.1.tar" in "_site/downloads/index.html"
