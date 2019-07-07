Feature: Post excerpts
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But some people can only focus for a few moments
  So just give them a taste

  Scenario: An excerpt without a layout
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see exactly "<p>content for entry1.</p>" in "_site/index.html"

  Scenario: An excerpt from a post with a layout
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ page.excerpt }}"
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the _site/2007 directory should exist
    And the _site/2007/12 directory should exist
    And the _site/2007/12/31 directory should exist
    And the "_site/2007/12/31/entry1.html" file should exist
    And I should see exactly "<p>content for entry1.</p>" in "_site/2007/12/31/entry1.html"
    And I should see exactly "<p>content for entry1.</p>" in "_site/index.html"

  Scenario: An excerpt with Liquid constructs from a post with a layout
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a configuration file with "baseurl" set to "/blog"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ page.excerpt }}"
    And I have the following posts:
      | title  | date       | layout | content                                  |
      | entry1 | 2007-12-31 | post   | {{ 'assets/style.css' \| relative_url }} |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the _site/2007 directory should exist
    And the _site/2007/12 directory should exist
    And the _site/2007/12/31 directory should exist
    And the "_site/2007/12/31/entry1.html" file should exist
    And I should see exactly "<p>/blog/assets/style.css</p>" in "_site/2007/12/31/entry1.html"
    And I should see exactly "<p>/blog/assets/style.css</p>" in "_site/index.html"

  Scenario: An excerpt from a post with a layout which has context
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "<html><head></head><body>{{ page.excerpt }}</body></html>"
    And I have the following posts:
      | title  | date       | layout | content             |
      | entry1 | 2007-12-31 | post   | content for entry1. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the _site/2007 directory should exist
    And the _site/2007/12 directory should exist
    And the _site/2007/12/31 directory should exist
    And the "_site/2007/12/31/entry1.html" file should exist
    And I should see "<p>content for entry1.</p>" in "_site/index.html"
    And I should see "<html><head></head><body><p>content for entry1.</p>\n</body></html>" in "_site/2007/12/31/entry1.html"

  Scenario: Excerpts from posts having 'render_with_liquid' in their front matter
    Given I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _posts directory
    And I have a _layouts directory
    And I have a post layout that contains "{{ page.excerpt }}"
    And I have the following posts:
      | title           | layout | render_with_liquid | date       | content                                  |
      | Unrendered Post | post   | false              | 2017-07-06 | Liquid is not rendered at {{ page.url }} |
      | Rendered Post   | post   | true               | 2017-07-06 | Liquid is rendered at {{ page.url }}     |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site/2017/07/06 directory should exist
    And the "_site/2017/07/06/unrendered-post.html" file should exist
    And the "_site/2017/07/06/rendered-post.html" file should exist
    And I should see "Liquid is not rendered at {{ page.url }}" in "_site/2017/07/06/unrendered-post.html"
    But I should see "<p>Liquid is rendered at /2017/07/06/rendered-post.html</p>" in "_site/2017/07/06/rendered-post.html"
    And I should see "<p>Liquid is not rendered at {{ page.url }}</p>\n<p>Liquid is rendered at /2017/07/06/rendered-post.html</p>" in "_site/index.html"

  Scenario: Excerpts from posts with reference-style Markdown links
    Given I have a configuration file with:
      | key       | value                   |
      | permalink | "/:title:output_ext"    |
      | kramdown  | { show_warnings: true } |
    And I have an "index.html" page that contains "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    And I have a _layouts directory
    And I have a post layout that contains "{{ page.excerpt }}"
    And I have a _posts directory
    And I have the following posts:
      | title                        | layout | date       | content                                                   |
      | Just Text Excerpt            | post   | 2019-03-06 | Install Jekyll\n\nNext Para [^1]\n\n[^1]: Lorem ipsum     |
      | Text and Footnote            | post   | 2019-03-07 | Alpha [^1]\n\nNext Para\n\n[^1]: Omega sigma              |
      | Text and Reference Link      | post   | 2019-03-08 | Read [docs][link]\n\nNext Para\n\n[link]: docs.jekyll.com |
      | Text and Self-refencing Link | post   | 2019-03-09 | Check out [jekyll]\n\nNext Para\n\n[jekyll]: jekyllrb.com |
    When I run jekyll build
    Then I should get a zero exit status
    And I should not see "Kramdown warning" in the build output
    But I should see exactly "<p>Install Jekyll</p>" in "_site/just-text-excerpt.html"
    And I should see "<p>Alpha <sup id=\"fnref:1\"><a href=\"#fn:1\" class=\"footnote\">1</a></sup></p>" in "_site/text-and-footnote.html"
    And I should see "<p>Omega sigma <a href=\"#fnref:1\" class=\"reversefootnote\">&#8617;</a></p>" in "_site/text-and-footnote.html"
    And I should see "<p>Read <a href=\"docs.jekyll.com\">docs</a></p>" in "_site/text-and-reference-link.html"
    And I should see "<p>Check out <a href=\"jekyllrb.com\">jekyll</a></p>" in "_site/text-and-self-refencing-link.html"
