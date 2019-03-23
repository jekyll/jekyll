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

  Scenario: highlighting an Liquid example
    Given I have an "inspect.md" file with content:
    """
    ---
    title: Inspect Filter
    ---
    You can inspect a page's attributes with the `inspect` filter. You may enclose the
    entire introspection within `<pre></pre>` tags to preserve the formatting:
    {% highlight html %}
    <pre id="inspect-filter">
      {{ page | inspect }}
    </pre>
    {% endhighlight %}
    """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<code class=\"language-html\" data-lang=\"html\">" in "_site/inspect.html"
    And I should see "{{ page | inspect }}" in "_site/inspect.html"

  Scenario: highlighting an included snippet
    Given I have an _includes directory
    And I have an "_includes/inspector.html" file with content:
    """
    <pre id="inspect-filter">
      {{ page | inspect }}
    </pre>
    """
    And I have an "inspect.md" file with content:
    """
    ---
    title: Inspect Filter
    ---
    You can inspect a page's attributes with the `inspect` filter. You may enclose the
    entire introspection within `<pre></pre>` tags to preserve the formatting:
    {% highlight html %}
      {% include inspector.html %}
    {% endhighlight %}
    """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<code class=\"language-html\" data-lang=\"html\">" in "_site/inspect.html"
    But I should not see "{{ page | inspect }}" in "_site/inspect.html"
    But I should see "{% include inspector.html %}" in "_site/inspect.html"
