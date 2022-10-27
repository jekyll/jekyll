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

  Scenario: highlighting lines 1 and 2 in a Ruby code block with valid syntax
    Given I have an "index.html" page with content:
      """
      {% highlight ruby highlight_lines="1 2" %}
      module Jekyll
        module Tags
          class HighlightBlock < Liquid::Block
      {% endhighlight %}
      """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<span class=\"hll\"><span class=\"k\">module</span> <span class=\"nn\">Jekyll</span>" in "_site/index.html"
    And I should see "<span class=\"hll\">  <span class=\"k\">module</span> <span class=\"nn\">Tags</span>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">HighlightBlock</span" in "_site/index.html"

  Scenario: highlighting a single line in a Ruby code block with invalid syntax
    Given I have an "index.html" page with content:
      """
      {% highlight ruby highlight_lines=1 %}
      module Jekyll
        module Tags
          class HighlightBlock < Liquid::Block
      {% endhighlight %}
      """
    When I run jekyll build
    Then I should see "Liquid Exception: Syntax Error" in the build output

  Scenario: highlighting lines 1 and 2 in a Ruby code block using a custom class name with valid syntax
    Given I have an "index.html" page with content:
      """
      {% highlight ruby highlight_lines="1 2" highlight_line_class=myclass %}
      module Jekyll
        module Tags
          class HighlightBlock < Liquid::Block
      {% endhighlight %}
      """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<span class=\"myclass\"><span class=\"k\">module</span> <span class=\"nn\">Jekyll</span>" in "_site/index.html"
    And I should see "<span class=\"myclass\">  <span class=\"k\">module</span> <span class=\"nn\">Tags</span>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">HighlightBlock</span" in "_site/index.html"

  Scenario: highlighting lines 1 and 2 in a Ruby code block using a custom class name in double-quotes
    Given I have an "index.html" page with content:
      """
      {% highlight ruby highlight_lines="1 2" highlight_line_class="1 2" %}
      module Jekyll
        module Tags
          class HighlightBlock < Liquid::Block
      {% endhighlight %}
      """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<span class=\"1 2\"><span class=\"k\">module</span> <span class=\"nn\">Jekyll</span>" in "_site/index.html"
    And I should see "<span class=\"1 2\">  <span class=\"k\">module</span> <span class=\"nn\">Tags</span>" in "_site/index.html"
    And I should see "<span class=\"k\">class</span> <span class=\"nc\">HighlightBlock</span" in "_site/index.html"
