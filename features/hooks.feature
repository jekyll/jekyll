Feature: Hooks
  As a plugin author
  I want to be able to run code during various stages of the build process

  Scenario: Run some code after site reset
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :site, :after_reset do |site|
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
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "mytinypage" in "_site/foo.html"

  Scenario: Modify the payload before rendering the site
    Given I have a _plugins directory
    And I have a "index.html" page that contains "{{ site.injected }}!"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :site, :pre_render do |site, payload|
      payload['site']['injected'] = 'myparam'
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "myparam!" in "_site/index.html"

  Scenario: Modify the site contents after reading
    Given I have a _plugins directory
    And I have a "page1.html" page that contains "page1"
    And I have a "page2.html" page that contains "page2"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :site, :post_read do |site|
      site.pages.delete_if { |p| p.name == 'page1.html' }
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/page1.html" file should not exist
    And I should see "page2" in "_site/page2.html"

  Scenario: Work with the site files after they've been written to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :site, :post_write do |site|
      firstpage = site.pages.first
      content = File.read firstpage.destination(site.dest)
      File.write(File.join(site.dest, 'firstpage.html'), content)
    end
    """
    And I have a "page1.html" page that contains "page1"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "page1" in "_site/firstpage.html"

  Scenario: Alter a page right after it is initialized
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :post_init do |page|
      page.name = 'renamed.html'
      page.process(page.name)
    end
    """
    And I have a "page1.html" page that contains "page1"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "page1" in "_site/renamed.html"

  Scenario: Alter the payload for one page but not another
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :pre_render do |page, payload|
      payload['page']['myparam'] = 'special' if page.name == 'page1.html'
    end
    """
    And I have a "page1.html" page that contains "{{ page.myparam }}"
    And I have a "page2.html" page that contains "{{ page.myparam }}"
    When I run jekyll build
    Then I should see "special" in "_site/page1.html"
    And I should not see "special" in "_site/page2.html"

  Scenario: Modify the Markdown content of a page before it is converted
    Given I have a _layouts directory
    And I have a "_layouts/page.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "page.md" page with layout "page" that contains "### Heading"
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :pre_convert do |page|
      page.content = page.content.gsub('###', '####')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/page.html"
    And I should see "<h4 id=\"heading\">Heading</h4>" in "_site/page.html"

  Scenario: Modify the converted HTML content of a page before rendering layout
    Given I have a _layouts directory
    And I have a "_layouts/page.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "page.md" page with layout "page" that contains "### Heading"
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :post_convert do |page|
      page.content = page.content.gsub('h3', 'h4')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/page.html"
    And I should see "<h4 id=\"heading\">Heading</h4>" in "_site/page.html"

  Scenario: Modify page contents before writing to disk
    Given I have a _plugins directory
    And I have a "index.html" page that contains "WRAP ME"
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :post_render do |page|
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
    Jekyll::Hooks.register :pages, :post_write do |page|
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
    Jekyll::Hooks.register :posts, :post_init do |post|
      post.data['harold'] = "content for entry1.".tr!('abcdefghijklmnopqrstuvwxyz',
            'nopqrstuvwxyzabcdefghijklm')
    end
    """
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content               |
      | entry1 | 2015-03-14 | nil    | {{ page.harold }} |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "pbagrag sbe ragel1." in "_site/2015/03/14/entry1.html"

  Scenario: Alter the payload for certain posts
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # Add myvar = 'old' to posts before 2015-03-15, and myvar = 'new' for
    # others
    Jekyll::Hooks.register :posts, :pre_render do |post, payload|
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

  Scenario: Modify the Markdown content of a post before it is converted
    Given I have a _layouts directory
    And I have a "_layouts/post.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a _posts directory
    And I have a "_posts/2016-01-01-example.md" file with content:
    """
    ---
    layout: post
    ---
    ### Heading
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :posts, :pre_convert do |post|
      post.content = post.content.gsub('###', '####')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/2016/01/01/example.html"
    And I should see "<h4 id=\"heading\">Heading</h4>" in "_site/2016/01/01/example.html"

  Scenario: Modify the converted HTML content of a post before rendering layout
    Given I have a _layouts directory
    And I have a "_layouts/post.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a _posts directory
    And I have a "_posts/2016-01-01-example.md" file with content:
    """
    ---
    layout: post
    ---
    ### Heading
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :posts, :post_convert do |post|
      post.content = post.content.gsub('h3', 'h4')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/2016/01/01/example.html"
    And I should see "<h4 id=\"heading\">Heading</h4>" in "_site/2016/01/01/example.html"

  Scenario: Modify post contents before writing to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    # Replace content after rendering
    Jekyll::Hooks.register :posts, :post_render do |post|
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
    Jekyll::Hooks.register :posts, :post_write do |post|
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

  Scenario: Register a hook on multiple owners at the same time
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register [:pages, :posts], :post_render do |owner|
      owner.output = "{{{{{ #{owner.output.chomp} }}}}}"
    end
    """
    And I have a "index.html" page that contains "WRAP ME"
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content   |
      | entry1 | 2015-03-14 | nil    | entry one |
    When I run jekyll build
    Then I should see "{{{{{ WRAP ME }}}}}" in "_site/index.html"
    And I should see "{{{{{ <p>entry one</p> }}}}}" in "_site/2015/03/14/entry1.html"

  Scenario: Allow hooks to have a named priority
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :post_render, priority: :normal do |owner|
      # first normal runs second
      owner.output = "1 #{owner.output.chomp}"
    end
    Jekyll::Hooks.register :pages, :post_render, priority: :high do |owner|
      # high runs first
      owner.output = "2 #{owner.output.chomp}"
    end
    Jekyll::Hooks.register :pages, :post_render do |owner|
      # second normal runs third (normal is default)
      owner.output = "3 #{owner.output.chomp}"
    end
    Jekyll::Hooks.register :pages, :post_render, priority: :low do |owner|
      # low runs last
      owner.output = "4 #{owner.output.chomp}"
    end
    """
    And I have a "index.html" page that contains "WRAP ME"
    When I run jekyll build
    Then I should see "4 3 1 2 WRAP ME" in "_site/index.html"

  Scenario: Alter a document right after it is initialized
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :documents, :pre_render do |doc, payload|
      doc.data['text'] = doc.data['text'] << ' are belong to us'
    end
    """
    And I have a "_config.yml" file that contains "collections: [ memes ]"
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    text: all your base
    ---
    """
    And I have an "index.md" file with content:
    """
    ---
    ---
    {{ site.memes.first.text }}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "all your base are belong to us" in "_site/index.html"

  Scenario: Modify the Markdown content of a document before it is converted
    Given I have a _layouts directory
    And I have a "_layouts/meme.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :documents, :pre_convert do |document|
      document.content = document.content.gsub('###', '####')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/memes/doc1.html"
    And I should see "<h4 id=\"all-your-base\">all your base</h4>" in "_site/memes/doc1.html"

  Scenario: Modify the converted HTML content of a document before rendering layout
    Given I have a _layouts directory
    And I have a "_layouts/meme.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :documents, :post_convert do |document|
      document.content = document.content.gsub('h3', 'h4')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/memes/doc1.html"
    And I should see "<h4 id=\"all-your-base\">all your base</h4>" in "_site/memes/doc1.html"

  Scenario: Modify the Markdown content of document of a particular collection before it is converted
    Given I have a _layouts directory
    And I have a "_layouts/meme.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _posts directory
    And I have a "_posts/2016-01-01-example.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :memes, :pre_convert do |document|
      document.content = document.content.gsub('###', '####')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/memes/doc1.html"
    And I should see "<h4 id=\"all-your-base\">all your base</h4>" in "_site/memes/doc1.html"
    But I should see "<h3 id=\"all-your-base\">all your base</h3>" in "_site/2016/01/01/example.html"

  Scenario: Modify the converted HTML content of document of a particular collection before rendering layout
    Given I have a _layouts directory
    And I have a "_layouts/meme.html" file with content:
    """
    <h3>Page heading</h3>
    {{ content }}
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _posts directory
    And I have a "_posts/2016-01-01-example.md" file with content:
    """
    ---
    layout: meme
    text: all your base
    ---
    ### {{ page.text }}
    """
    And I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :memes, :post_convert do |document|
      document.content = document.content.gsub('h3', 'h4')
    end
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<h3>Page heading</h3>" in "_site/memes/doc1.html"
    And I should see "<h4 id=\"all-your-base\">all your base</h4>" in "_site/memes/doc1.html"
    But I should see "<h3 id=\"all-your-base\">all your base</h3>" in "_site/2016/01/01/example.html"

  Scenario: Update a document after rendering it, but before writing it to disk
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :documents, :post_render do |doc|
      doc.output.gsub! /<p>/, '<p class="meme">'
    end
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    text: all your base are belong to us
    ---
    {{ page.text }}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p class=\"meme\">all your base are belong to us" in "_site/memes/doc1.html"

  Scenario: Perform an action after every document is written
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :documents, :post_write do |doc|
      open('_site/document-build.log', 'a') do |f|
        f.puts "Wrote document #{doc.collection.docs.index doc} at #{Time.now}"
      end
    end
    """
    And I have a "_config.yml" file with content:
    """
    collections:
      memes:
        output: true
    """
    And I have a _memes directory
    And I have a "_memes/doc1.md" file with content:
    """
    ---
    text: all your base are belong to us
    ---
    {{ page.text }}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Wrote document 0" in "_site/document-build.log"

  Scenario: Set a custom payload['page'] property
    Given I have a _plugins directory
    And I have a "_plugins/ext.rb" file with content:
    """
    Jekyll::Hooks.register :pages, :pre_render do |page, payload|
        payload['page']['foo'] = "hello world"
    end
    """
    And I have a _layouts directory
    And I have a "_layouts/custom.html" file with content:
      """
      ---
      ---
      {{ content }} {% include foo.html %}
      """
    And I have a _includes directory
    And I have a "_includes/foo.html" file with content:
      """
      {{page.foo}}
      """
    And I have an "index.html" page with layout "custom" that contains "page content"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "page content\n hello world" in "_site/index.html"
