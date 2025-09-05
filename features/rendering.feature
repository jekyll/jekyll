Feature: Rendering
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But I want to make it as simply as possible
  So render with Liquid and place in Layouts

  Scenario: Rendering a site with parentheses in its path name
    Given I have a blank site in "omega(beta)"
    And   I have an "omega(beta)/test.md" page with layout "simple" that contains "Hello World"
    And   I have an omega(beta)/_includes directory
    And   I have an "omega(beta)/_includes/head.html" file that contains "Snippet"
    And   I have a configuration file with "source" set to "omega(beta)"
    And   I have an omega(beta)/_layouts directory
    And   I have an "omega(beta)/_layouts/simple.html" file that contains "{% include head.html %}: {{ content }}"
    When  I run jekyll build --profile
    Then  I should get a zero exit status
    And   I should see "Snippet: <p>Hello World</p>" in "_site/test.html"
    And   I should see "_layouts/simple.html" in the build output

  Scenario: When receiving bad Liquid
    Given I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception" in the build output

  Scenario: When receiving a liquid syntax error in included file
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{% INVALID %}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid syntax error \(.+/invalid\.html line 1\): Unknown tag 'INVALID' included in index\.html" in the build output

  Scenario: When receiving a generic liquid error in included file
    Given I have a _includes directory
    And   I have a "_includes/invalid.html" file that contains "{{ site.title | prepend 'Prepended Text' }}"
    And   I have a "index.html" page with layout "simple" that contains "{% include invalid.html %}"
    And   I have a simple layout that contains "{{ content }}"
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid Exception: Liquid error \(.+/_includes/invalid\.html line 1\): wrong number of arguments (\(given 1, expected 2\)|\(1 for 2\)) included in index\.html" in the build output

  Scenario: Rendering a default site containing a file with rogue Liquid constructs
    Given I have a "index.html" page with title "Simple Test" that contains "{{ page.title | foobar }}\n\n{{ page.author }}"
    When  I run jekyll build
    Then  I should get a zero exit-status
    And   I should not see "Liquid Exception:" in the build output

  Scenario: Rendering a default site containing a file with a non-existent Liquid variable
    Given I have a "index.html" file with content:
    """
    ---
    title: Simple Test
    ---
    {{ site.lorem.ipsum }}
    {{ site.title }}
    """
    And  I have a configuration file with "title" set to "Hello World"
    When I run jekyll build
    Then I should get a zero exit-status
    And  the _site directory should exist

  Scenario: Rendering a custom site containing a file with a non-existent Liquid variable
    Given I have a "index.html" file with content:
    """
    ---
    title: Simple Test
    ---
    {{ page.title }}

    {{ page.author }}
    """
    And   I have a "_config.yml" file with content:
    """
    liquid:
      strict_variables: true
    """
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid error \(line 3\): undefined variable author in index.html" in the build output

  Scenario: Rendering a custom site containing a file with a non-existent Liquid filter
    Given I have a "index.html" file with content:
    """
    ---
    author: John Doe
    ---
    {{ page.title }}

    {{ page.author | foobar }}
    """
    And   I have a "_config.yml" file with content:
    """
    liquid:
      strict_filters: true
    """
    When  I run jekyll build
    Then  I should get a non-zero exit-status
    And   I should see "Liquid error \(line 3\): undefined filter foobar in index.html" in the build output

  Scenario: Render Liquid and place in layout
    Given I have a "index.html" page with layout "simple" that contains "Hi there, Jekyll {{ jekyll.environment }}!"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Hi there, Jekyll development!\nAhoy, indeed" in "_site/index.html"

  Scenario: Don't place asset files in layout
    Given I have an "index.scss" page with layout "simple" that contains ".foo-bar { color:black; }"
    And I have an "index.coffee" page with layout "simple" that contains "whatever()"
    And I have a configuration file with "plugins" set to "[jekyll-coffeescript]"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Ahoy, indeed!" in "_site/index.css"
    And I should not see "Ahoy, indeed!" in "_site/index.js"

  Scenario: Ignore defaults and don't place pages and documents with layout set to 'none'
    Given I have a "index.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a _trials directory
    And I have a "_trials/no-layout.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a "_trials/test.md" page with layout "null" that contains "Hi there, {{ site.author }}!"
    And I have a none layout that contains "{{ content }}Welcome!"
    And I have a page layout that contains "{{ content }}Check this out!"
    And I have a configuration file with:
    | key             | value                                          |
    | author          | John Doe                                       |
    | collections     | {trials: {output: true}}                       |
    | defaults        | [{scope: {path: ""}, values: {layout: page}}]  |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Welcome!" in "_site/trials/no-layout.html"
    And I should not see "Check this out!" in "_site/trials/no-layout.html"
    But I should see "Check this out!" in "_site/trials/test.html"
    And I should see "Hi there, John Doe!" in "_site/index.html"
    And I should not see "Welcome!" in "_site/index.html"
    And I should not see "Build Warning:" in the build output

  Scenario: Don't place pages and documents with layout set to 'none'
    Given I have a "index.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a _trials directory
    And I have a "_trials/no-layout.md" page with layout "none" that contains "Hi there, {{ site.author }}!"
    And I have a "_trials/test.md" page with layout "page" that contains "Hi there, {{ site.author }}!"
    And I have a none layout that contains "{{ content }}Welcome!"
    And I have a page layout that contains "{{ content }}Check this out!"
    And I have a configuration file with:
    | key             | value                     |
    | author          | John Doe                  |
    | collections     | {trials: {output: true}}  |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should not see "Welcome!" in "_site/trials/no-layout.html"
    And I should not see "Welcome!" in "_site/index.html"
    But I should see "Check this out!" in "_site/trials/test.html"
    And I should see "Hi there, John Doe!" in "_site/index.html"
    And I should not see "Build Warning:" in the build output

  Scenario: Render liquid in Sass
    Given I have an "index.scss" page that contains ".foo-bar { color:{{site.color}}; }"
    And I have a configuration file with "color" set to "red"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see ".foo-bar {\n  color: red;\n}\n\n\/\*# sourceMappingURL=index.css.map \*\/" in "_site/index.css"

  Scenario: Not render liquid in CoffeeScript without explicitly including jekyll-coffeescript
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/index.js" file should not exist

  Scenario: Render liquid in CoffeeScript with jekyll-coffeescript enabled
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    And I have a configuration file with "plugins" set to "[jekyll-coffeescript]"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "hey = 'for cicada';" in "_site/index.js"

  Scenario: Rendering Liquid expressions that return strings containing Liquid expressions
    Given I have an "index.md" file with content:
      """
      ---
      prequel: "{% link series/first-part.md %}"
      sequel: "{% link series/last-part.md %}"
      ---

      This is the second-part of the series named {{ site.novel }}.
      The first part is at {{ page.prequel }}.

      Lorem ipsum

      {% capture sequel_link %}{{ page.sequel }}{% endcapture %}
      The last part of the series can be read at {{ sequel_link }}
      """
    And I have a configuration file with "novel" set to "'{{ site.title }}'"
    When I run jekyll build
    Then I should get a zero exit status
    And I should see "series named {{ site.title }}" in "_site/index.html"
    And I should see "{% link series/first-part.md %}" in "_site/index.html"
    And I should see "{% link series/last-part.md %}" in "_site/index.html"

  Scenario: Render content of another page
    Given I have an "index.md" page that contains "__Hello World__"
    And I have an "about.md" page that contains "{{ page.name }}"
    And I have a "test.json" file with content:
      """
      ---
      ---

      {
        "hpages": [
          {%- for page in site.html_pages %}
          {
            "url"    : {{ page.url     | jsonify }},
            "name"   : {{ page.name    | jsonify }},
            "path"   : {{ page.path    | jsonify }},
            "title"  : {{ page.title   | jsonify }},
            "layout" : {{ page.layout  | jsonify }},
            "content": {{ page.content | jsonify }},
            "excerpt": {{ page.excerpt | jsonify }}
          }{% unless forloop.last %},{% endunless -%}
          {% endfor %}
        ]
      }
      """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    But I should not see "content\": \"{{ page.name }}" in "_site/test.json"
    And I should not see "content\": \"__Hello World__" in "_site/test.json"
    But I should see "content\": \"<p>about.md</p>" in "_site/test.json"
    And I should see "content\": \"<p><strong>Hello World</strong></p>" in "_site/test.json"

  Scenario: Render layout front matter data
    Given I have an "alpha.md" page with layout "orchard" that contains "item on sale: {{ layout.item }}"
    And I have an "beta.md" page with layout "bakery" that contains "item on sale: {{ layout.item }}"
    And I have a "bakery.html" layout with data:
    | key  | value       |
    | item | Carrot Cake |
    And I have an "orchard.html" layout with data:
    | key  | value               |
    | item | Granny Smith Apples |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "item on sale: Granny Smith Apples" in "_site/alpha.html"
    And I should see "item on sale: Carrot Cake" in "_site/beta.html"
