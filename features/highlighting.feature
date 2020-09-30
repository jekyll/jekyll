Feature: Syntax Highlighting
  As a hacker who likes to blog
  I want to share code snippets in my blog
  And make them pretty for all the world to see

  Scenario: highlighting an apache configuration
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% highlight apache %}
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteRule ^(.*)$ index.php [QSA,L]
      {% endhighlight %}

      ```apache
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteRule ^(.*)$ index.php [QSA,L]
      ```
      """
    And I have a "_config.yml" file with content:
      """
      kramdown:
        input: GFM
      """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<span class="nc">RewriteCond</span>" in "_site/index.html"

  Scenario: Highlighting with the 'rougify' tag with default options
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% rougify ruby %}
      class Foo
        def bar
          puts "Hello World"
        end
      end
      {% endrougify %}
      """
    And I have a configuration file with "title" set to "Sample Site"
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<div class=\"language-ruby highlighter-rouge\"><div class=\"highlight\">" in "_site/index.html"
    And I should see "<pre class=\"highlight\"><code>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">Foo</span>" in "_site/index.html"

  Scenario: Highlighting with the 'rougify' tag and rendering line numbers
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% rougify ruby linenos = true %}
      class Foo
        def bar
          puts "Hello World"
        end
      end
      {% endrougify %}
      """
    And I have a configuration file with "title" set to "Sample Site"
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<div class=\"language-ruby highlighter-rouge\"><div class=\"highlight\">" in "_site/index.html"
    And I should not see "<pre class=\"highlight\"><code>" in "_site/index.html"
    And I should see "<table class=\"rouge-line-table\"><tbody>" in "_site/index.html"
    And I should see "<tr data-line-id=\"line-1\" class=\"lineno\"><td class=\"rouge-gutter gl\"" in "_site/index.html"
    And I should see "<pre>1</pre></td><td class=\"rouge-code\"><pre>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">Foo</span>" in "_site/index.html"

  Scenario: Highlighting with the 'rougify' tag and rendering annotation
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% rougify ruby annotated = true %}
      class Foo
        def bar
          puts "Hello World"
        end
      end
      {% endrougify %}
      """
    And I have a configuration file with "title" set to "Sample Site"
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<div class=\"language-ruby highlighter-rouge\">" in "_site/index.html"
    And I should see "<div class=\"code-block-lang\"><div>ruby</div></div><div class=\"highlight\">" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">Foo</span>" in "_site/index.html"

  Scenario: Highlighting with the 'rougify' tag and rendering line numbers and annotation
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% rougify ruby annotated = true linenos = true %}
      class Foo
        def bar
          puts "Hello World"
        end
      end
      {% endrougify %}
      """
    And I have a configuration file with "title" set to "Sample Site"
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<div class=\"language-ruby highlighter-rouge\">" in "_site/index.html"
    And I should see "<div class=\"code-block-lang\"><div>ruby</div></div><div class=\"highlight\">" in "_site/index.html"
    And I should see "<table class=\"rouge-line-table\"><tbody>" in "_site/index.html"
    And I should see "<tr data-line-id=\"line-1\" class=\"lineno\"><td class=\"rouge-gutter gl\"" in "_site/index.html"
    And I should see "<pre>1</pre></td><td class=\"rouge-code\"><pre>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">Foo</span>" in "_site/index.html"

  Scenario: Highlighting with the 'rougify' tag and rendering line numbers with table-id
    Given I have an "index.html" file with content:
      """
      ---
      ---

      {% rougify ruby linenos = true table_id = "test" %}
      class Foo
        def bar
          puts "Hello World"
        end
      end
      {% endrougify %}
      """
    And I have a configuration file with "title" set to "Sample Site"
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<div class=\"language-ruby highlighter-rouge\">" in "_site/index.html"
    And I should see "<table id=\"test\" class=\"rouge-line-table\"><tbody>" in "_site/index.html"
    And I should see "<tr id=\"test-line-1\" data-line-id=\"line-1\" class=\"lineno\"><td class=\"rouge-gutter gl\"" in "_site/index.html"
    And I should see "<pre>1</pre></td><td class=\"rouge-code\"><pre>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">Foo</span>" in "_site/index.html"
