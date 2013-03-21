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
    And I have the following post:
      | title | date | layout | content |
      | Include Files | 3/21/2013 | default | {% include header.html param=myparam %} |
      | Ignore params if unused | 3/21/2013 | default | {% include ignore.html date=today %} |
      | List multiple parameters | 3/21/2013 | default | {% include params.html date=today, start=tomorrow %} |
      | Dont keep parameters | 3/21/2013 | default | {% include ignore.html param=test %}\n{% include header.html %} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "<header>My awesome blog header: myparam</header>" in "_site/2013/03/21/include-files.html"
    And I should not see "myparam" in "_site/2013/03/21/ignore-params-if-unused.html"
    And I should see "<ul><li>date = today</li><li>start = tomorrow</li></ul>" in "_site/2013/03/21/list-multiple-parameters.html"
    And I should not see "<header>My awesome blog header: myparam</header>" in "_site/2013/03/21/dont-keep-parameters.html"
    But I should see "<header>My awesome blog header: </header>" in "_site/2013/03/21/dont-keep-parameters.html"