Feature: Include tags
  In order to share their content across several pages
  As a hacker who likes to blog
  I want to be able to include files in my blog posts

  Scenario: Include a file with parameters
    Given I have an _includes directory
    And I have an "_includes/header.html" file that contains "<header>My awesome blog header: {{include.param}}</header>"
    And I have an "_includes/params.html" file that contains "Parameters:<ul>{% for param in include %}<li>{{param[0]}} = {{param[1]}}</li>{% endfor %}</ul>"
    And I have an "_includes/ignore.html" file that contains "<footer>My blog footer</footer>"
    And I have a _posts directory
    And I have the following posts:
      | title                               | date       | type | content                                                                                                                 |
      | Include Files                       | 2013-03-21 | html | {% include header.html param="myparam" %}                                                                               |
      | Ignore params if unused             | 2013-03-21 | html | {% include ignore.html date="today" %}                                                                                  |
      | List multiple parameters            | 2013-03-21 | html | {% include params.html date="today" start="tomorrow" %}                                                                 |
      | Dont keep parameters                | 2013-03-21 | html | {% include ignore.html param="test" %}\n{% include header.html %}                                                       |
      | Allow params with spaces and quotes | 2013-04-07 | html | {% include params.html cool="param with spaces" super="\"quoted\"" single='has "quotes"' escaped='\'single\' quotes' %} |
      | Parameter syntax                    | 2013-04-12 | html | {% include params.html param1_or_2="value" %}                                                                           |
      | Pass a variable                     | 2013-06-22 | html | {% assign var = 'some text' %}{% include params.html local=var title=page.title %}                                    |
    When I run jekyll build
    Then the _site directory should exist
    And I should see "<header>My awesome blog header: myparam</header>" in "_site/2013/03/21/include-files.html"
    And I should not see "myparam" in "_site/2013/03/21/ignore-params-if-unused.html"
    And I should see "<li>date = today</li>" in "_site/2013/03/21/list-multiple-parameters.html"
    And I should see "<li>start = tomorrow</li>" in "_site/2013/03/21/list-multiple-parameters.html"
    And I should not see "<header>My awesome blog header: myparam</header>" in "_site/2013/03/21/dont-keep-parameters.html"
    But I should see "<header>My awesome blog header: </header>" in "_site/2013/03/21/dont-keep-parameters.html"
    And I should see "<li>cool = param with spaces</li>" in "_site/2013/04/07/allow-params-with-spaces-and-quotes.html"
    And I should see "<li>super = \"quoted\"</li>" in "_site/2013/04/07/allow-params-with-spaces-and-quotes.html"
    And I should see "<li>single = has \"quotes\"</li>" in "_site/2013/04/07/allow-params-with-spaces-and-quotes.html"
    And I should see "<li>escaped = 'single' quotes</li>" in "_site/2013/04/07/allow-params-with-spaces-and-quotes.html"
    And I should see "<li>param1_or_2 = value</li>" in "_site/2013/04/12/parameter-syntax.html"
    And I should see "<li>local = some text</li>" in "_site/2013/06/22/pass-a-variable.html"
    And I should see "<li>title = Pass a variable</li>" in "_site/2013/06/22/pass-a-variable.html"

  Scenario: Include a file from a variable
    Given I have an _includes directory
    And I have an "_includes/snippet.html" file that contains "a snippet"
    And I have an "_includes/parametrized.html" file that contains "works with {{include.what}}"
    And I have a configuration file with:
    | key           | value             |
    | include_file1 | snippet.html      |
    | include_file2 | parametrized.html |
    And I have an "index.html" page that contains "{% include {{site.include_file1}} %} that {% include {{site.include_file2}} what='parameters' %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "a snippet that works with parameters" in "_site/index.html"

  Scenario: Include a variable file in a loop
    Given I have an _includes directory
    And I have an "_includes/one.html" file that contains "one"
    And I have an "_includes/two.html" file that contains "two"
    And I have an "index.html" page with files "[one.html, two.html]" that contains "{% for file in page.files %}{% include {{file}} %} {% endfor %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "one two" in "_site/index.html"

  Scenario: Include a file with variables and filters
    Given I have an _includes directory
    And I have an "_includes/one.html" file that contains "one included"
    And I have a configuration file with:
    | key          | value |
    | include_file | one   |
    And I have an "index.html" page that contains "{% include {{ site.include_file | append: '.html' }} %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "one included" in "_site/index.html"

  Scenario: Include a file with partial variables
    Given I have an _includes directory
    And I have an "_includes/one.html" file that contains "one included"
    And I have a configuration file with:
    | key          | value |
    | include_file | one   |
    And I have an "index.html" page that contains "{% include {{ site.include_file }}.html %}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "one included" in "_site/index.html"
