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
