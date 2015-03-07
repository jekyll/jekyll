Feature: Hooks
  As a plugin author
  I want to be able to run code during various stages of the build process

  Scenario: Run some code on site reset
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Site, :reset do |site|
      pageklass = Class.new(Jekyll::Page) do
        def initialize(site, base)
          @site = site
          @base = base
          @data = {}
          @dir = '/'
          @name = 'foo.html'
          @content = 'mytinypage'

          self.process(@name)
        end
      end

      site.pages << pageklass.new(site, site.source)
    end
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "mytinypage" in "_site/foo.html"

  Scenario: Modify the payload before rendering the site
    Given I have a _plugins directory
    And I have a "index.html" page that contains "{{ site.injected }}!"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Site, :pre_render do |site, payload|
      payload['site']['injected'] = 'myparam'
    end
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "myparam!" in "_site/index.html"

  Scenario: Modify the site contents after reading
    Given I have a _plugins directory
    And I have a "page1.html" page that contains "page1"
    And I have a "page2.html" page that contains "page2"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Site, :post_read do |site|
      site.pages.delete_if { |p| p.name == 'page1.html' }
    end
    """
    When I run jekyll build
    Then the _site directory should exist
    And the "_site/page1.html" file should not exist
    And I should see "page2" in "_site/page2.html"

  Scenario: Work with the site files after they've been written to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Site, :post_write do |site|
      firstpage = site.pages.first
      content = File.read firstpage.destination(site.dest)
      File.write(File.join(site.dest, 'firstpage.html'), content)
    end
    """
    And I have a "page1.html" page that contains "page1"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "page1" in "_site/firstpage.html"

  Scenario: Alter a page right after it is initialized
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Page, :post_init do |page|
      page.name = 'renamed.html'
      page.process(page.name)
    end
    """
    And I have a "page1.html" page that contains "page1"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "page1" in "_site/renamed.html"

  Scenario: Alter the payload for one page but not another
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Page, :pre_render do |page, payload|
      payload['myparam'] = 'special' if page.name == 'page1.html'
    end
    """
    And I have a "page1.html" page that contains "{{ myparam }}"
    And I have a "page2.html" page that contains "{{ myparam }}"
    When I run jekyll build
    Then I should see "special" in "_site/page1.html"
    And I should not see "special" in "_site/page2.html"

  Scenario: Modify page contents before writing to disk
    Given I have a _plugins directory
    And I have a "index.html" page that contains "WRAP ME"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Page, :post_render do |page|
      page.output = "{{{{{ #{page.output.chomp} }}}}}"
    end
    """
    When I run jekyll build
    Then I should see "{{{{{ WRAP ME }}}}}" in "_site/index.html"

  Scenario: Work with a page after writing it to disk
    Given I have a _plugins directory
    And I have a "index.html" page that contains "HELLO FROM A PAGE"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register Jekyll::Page, :post_write do |page|
      require 'fileutils'
      filename = page.destination(page.site.dest)
      FileUtils.mv(filename, "#{filename}.moved")
    end
    """
    When I run jekyll build
    Then I should see "HELLO FROM A PAGE" in "_site/index.html.moved"

  Scenario: Alter a post right after it is initialized
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # rot13 translate
    Jekyll::Hooks.register Jekyll::Post, :post_init do |post|
      post.content.tr!('abcdefghijklmnopqrstuvwxyz',
        'nopqrstuvwxyzabcdefghijklm')
    end
    """
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2015-03-14 | nil    | content for entry1. |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "pbagrag sbe ragel1." in "_site/2015/03/14/entry1.html"

  Scenario: Alter the payload for certain posts
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # Add myvar = 'old' to posts before 2015-03-15, and myvar = 'new' for
    # others
    Jekyll::Hooks.register Jekyll::Post, :pre_render do |post, payload|
      if post.date < Time.new(2015, 3, 15)
        payload['myvar'] = 'old'
      else
        payload['myvar'] = 'new'
      end
    end
    """
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content          |
      | entry1 | 2015-03-14 | nil    | {{ myvar }} post |
      | entry2 | 2015-03-15 | nil    | {{ myvar }} post |
    When I run jekyll build
    Then I should see "old post" in "_site/2015/03/14/entry1.html"
    And I should see "new post" in "_site/2015/03/15/entry2.html"

  Scenario: Modify post contents before writing to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # Replace content after rendering
    Jekyll::Hooks.register Jekyll::Post, :post_render do |post|
      post.output.gsub! /42/, 'the answer to life, the universe and everything'
    end
    """
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2015-03-14 | nil    | {{ 6 \| times: 7 }} |
      | entry2 | 2015-03-15 | nil    | {{ 6 \| times: 8 }} |
    When I run jekyll build
    Then I should see "the answer to life, the universe and everything" in "_site/2015/03/14/entry1.html"
    And I should see "48" in "_site/2015/03/15/entry2.html"

  Scenario: Work with a post after writing it to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # Log all post filesystem writes
    Jekyll::Hooks.register Jekyll::Post, :post_write do |post|
      filename = post.destination(post.site.dest)
      open('_site/post-build.log', 'a') do |f|
        f.puts "Wrote #{filename} at #{Time.now}"
      end
    end
    """
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content   |
      | entry1 | 2015-03-14 | nil    | entry one |
      | entry2 | 2015-03-15 | nil    | entry two |
    When I run jekyll build
    Then I should see "_site/2015/03/14/entry1.html at" in "_site/post-build.log"
    Then I should see "_site/2015/03/15/entry2.html at" in "_site/post-build.log"
