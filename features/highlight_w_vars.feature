Feature: Syntax Highlighting with Variables
  As a hacker who likes to blog
  I want to share code snippets in my blog
  And make them pretty for all the world to see

  Scenario: highlighting an apache configuration by using variables
    Given I have an "index.html" file with content:
      """
      ---
      lang: apache
      ---

      {% highlight {{ page.lang }} %}
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteRule ^(.*)$ index.php [QSA,L]
      {% endhighlight %}

      {% assign lines = 'linenos' %}
      {% highlight {{ page.lang }} {{ lines }} %}
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteRule ^(.*)$ index.php [QSA,L]
      {% endhighlight %}

      """
    And I have a "_config.yml" file with content:
      """
      kramdown:
        input: GFM
      """
    When I run jekyll build
    Then I should get a zero exit-status
    And I should see "<span class="nc">RewriteCond</span>" in "_site/index.html"
    And I should see "<pre class="lineno">1" in "_site/index.html"
