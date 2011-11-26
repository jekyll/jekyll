Feature: Haml
  As a cool hacker who likes to blog
  I tend to be DRY even in the layouts markup
  So I prefer to use Haml

  Background: lock&load!
    Given I have a _layouts directory
    And I have an "index.html" page with layout "default" that contains "I love it"

  Scenario: Haml in layouts
    Given I have a default.haml layout that contains:
    """
    !!! 5
    %html
      %body
        {{ content }}
    """
    When I run jekyll
    Then I should see "<!DOCTYPE html><html><body>I love it</body></html>" in "_site/index.html"

  Scenario: Preventing ruby evaluation via equals character
     Given I have a default.haml layout that contains:
     """
     %div
       %p= RUBY_VERSION
       %p {{ content }}
     """
     When I run jekyll
     Then I should see "<div><p></p><p>I love it</p></div>" in "_site/index.html"

  Scenario: Preventing ruby evaluation via hyphen character
     Given I have a default.haml layout that contains:
     """
     %div
       - require 'fileutils'
       - FileUtils.rm '/tmp/jekyll/log.txt' # this is our test directory
       %p {{ content }}
     """
     And I have a "log.txt" file that contains "I want to live!"
     When I run jekyll
     Then I should see "<div><p>I love it</p></div>" in "_site/index.html"
     And the "log.txt" file should exist

  Scenario: Preventing ruby blocks execution
     Given I have a default.haml layout that contains:
     """
     %div
       - 2.times do
         %p {{ content }}
     """
     When I run jekyll
     Then I should see "<div></div>" in "_site/index.html"

  Scenario: Preventing ruby evaluation via interpolation
     Given I have a default.haml layout that contains:
     """
     %div
       %p #{RUBY_VERSION}
     """
     When I run jekyll
     Then I should see "<div><p></p></div>" in "_site/index.html"