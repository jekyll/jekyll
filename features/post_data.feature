Feature: Post data
  As a hacker who likes to blog
  I want to be able to embed data into my posts
  In order to make the posts slightly dynamic

  Scenario: Use post.title variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post title: {{ page.title }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post title: Star Wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.url variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post url: {{ page.url }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post url: /2009/03/27/star-wars.html" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.date variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post date: {{ page.date | date_to_string }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post date: 27 Mar 2009" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.date variable with invalid
    Given I have a _posts directory
    And I have a "_posts/2016-01-01-test.md" page with date "tuesday" that contains "I have a bad date."
    When I run jekyll build
    Then the _site directory should not exist
    And I should see "Document '_posts/2016-01-01-test.md' does not have a valid date in the YAML front matter." in the build output

  Scenario: Invalid date in filename
    Given I have a _posts directory
    And I have a "_posts/2016-22-01-test.md" page that contains "I have a bad date."
    When I run jekyll build
    Then the _site directory should not exist
    And I should see "Document '_posts/2016-22-01-test.md' does not have a valid date in the filename." in the build output

  Scenario: Use post.id variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post id: {{ page.id }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post id: /2009/03/27/star-wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.content variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post content: {{ content }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post content: <p>Luke, I am your father.</p>" in "_site/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in a folder
    Given I have a movies directory
    And I have a movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies":
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in a folder and has category in YAML
    Given I have a movies directory
    And I have a movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies":
      | title     | date       | layout | category | content                 |
      | Star Wars | 2009-03-27 | simple | film     | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/film/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in a folder and has categories in YAML
    Given I have a movies directory
    And I have a movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies":
      | title     | date       | layout | categories        | content                 |
      | Star Wars | 2009-03-27 | simple | [film, scifi]     | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/film/scifi/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in a folder and duplicated category is in YAML
    Given I have a movies directory
    And I have a movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "movies":
      | title     | date       | layout | category | content                 |
      | Star Wars | 2009-03-27 | simple | movies   | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.tags variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | tag   | content                 |
      | Star Wars | 2009-05-18 | simple | twist | Luke, I am your father. |
    And I have a simple layout that contains "Post tags: {{ page.tags }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post tags: twist" in "_site/2009/05/18/star-wars.html"

  Scenario: Use post.categories variable when categories are in folders
    Given I have a scifi directory
    And I have a scifi/movies directory
    And I have a scifi/movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "scifi/movies":
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post categories: {{ page.categories | array_to_sentence_string }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post categories: scifi and movies" in "_site/scifi/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in folders with mixed case
    Given I have a scifi directory
    And I have a scifi/Movies directory
    And I have a scifi/Movies/_posts directory
    And I have a _layouts directory
    And I have the following post in "scifi/Movies":
      | title     | date       | layout | content                 |
      | Star Wars | 2009-03-27 | simple | Luke, I am your father. |
    And I have a simple layout that contains "Post categories: {{ page.categories | array_to_sentence_string }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post categories: scifi and Movies" in "_site/scifi/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in YAML
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | category | content                 |
      | Star Wars | 2009-03-27 | simple | movies   | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when category is in YAML and is mixed-case
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | category | content                 |
      | Star Wars | 2009-03-27 | simple | Movies   | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: Movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in YAML
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | categories          | content                 |
      | Star Wars | 2009-03-27 | simple | ['scifi', 'movies'] | Luke, I am your father. |
    And I have a simple layout that contains "Post categories: {{ page.categories | array_to_sentence_string }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post categories: scifi and movies" in "_site/scifi/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in YAML and are duplicated
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | categories           | content                 |
      | Star Wars | 2009-03-27 | simple | ['movies', 'movies'] | Luke, I am your father. |
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Superdirectories of _posts applied to post.categories
    Given I have a movies/_posts directory
    And I have a "movies/_posts/2009-03-27-star-wars.html" page with layout "simple" that contains "hi"
    And I have a _layouts directory
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Subdirectories of _posts not applied to post.categories
    Given I have a movies/_posts/scifi directory
    And I have a "movies/_posts/scifi/2009-03-27-star-wars.html" page with layout "simple" that contains "hi"
    And I have a _layouts directory
    And I have a simple layout that contains "Post category: {{ page.categories }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post category: movies" in "_site/movies/2009/03/27/star-wars.html"

  Scenario: Use post.categories variable when categories are in YAML with mixed case
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following posts:
      | title     | date       | layout | categories          | content                     |
      | Star Wars | 2009-03-27 | simple | ['scifi', 'Movies'] | Luke, I am your father.     |
      | Star Trek | 2013-03-17 | simple | ['SciFi', 'movies'] | Jean Luc, I am your father. |
    And I have a simple layout that contains "Post categories: {{ page.categories | array_to_sentence_string }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post categories: scifi and Movies" in "_site/scifi/movies/2009/03/27/star-wars.html"
    And I should see "Post categories: SciFi and movies" in "_site/scifi/movies/2013/03/17/star-trek.html"

Scenario: Use page.render_with_liquid variable
  Given I have a _posts directory
  And I have the following posts:
    | title           | render_with_liquid | date       | content                |
    | Unrendered Post | false              | 2017-07-06 | Hello {{ page.title }} |
    | Rendered Post   | true               | 2017-07-06 | Hello {{ page.title }} |
  When I run jekyll build
  Then I should get a zero exit status
  And the _site directory should exist
  And I should not see "Hello Unrendered Post" in "_site/2017/07/06/unrendered-post.html"
  But I should see "Hello {{ page.title }}" in "_site/2017/07/06/unrendered-post.html"
  And I should see "Hello Rendered Post" in "_site/2017/07/06/rendered-post.html"

  Scenario Outline: Use page.path variable
    Given I have a <dir>/_posts directory
    And I have the following post in "<dir>":
      | title   | type | date       | content                      |
      | my-post | html | 2013-04-12 | Source path: {{ page.path }} |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Source path: <path_prefix>_posts/2013-04-12-my-post.html" in "_site/<dir>/2013/04/12/my-post.html"

    Examples:
      | dir        | path_prefix |
      | .          |             |
      | dir        | dir/        |
      | dir/nested | dir/nested/ |

  Scenario: Cannot override page.path variable
    Given I have a _posts directory
    And I have the following post:
      | title    | date       | path               | content                      |
      | override | 2013-04-12 | override-path.html | Non-custom path: {{ page.path }} |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Non-custom path: _posts/2013-04-12-override.markdown" in "_site/2013/04/12/override.html"

  Scenario: Disable a post from being published
    Given I have a _posts directory
    And I have an "index.html" file that contains "Published!"
    And I have the following post:
      | title     | date       | layout | published | content                 |
      | Star Wars | 2009-03-27 | simple | false     | Luke, I am your father. |
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/2009/03/27/star-wars.html" file should not exist
    And I should see "Published!" in "_site/index.html"

  Scenario: Use a custom variable
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date       | layout | author      | content                 |
      | Star Wars | 2009-03-27 | simple | Darth Vader | Luke, I am your father. |
    And I have a simple layout that contains "Post author: {{ page.author }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Post author: Darth Vader" in "_site/2009/03/27/star-wars.html"

  Scenario: Use a variable which is a reserved keyword in Ruby
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title   | date       | layout | class     | content                 |
      | My post | 2016-01-21 | simple | kewl-post | Luke, I am your father. |
    And I have a simple layout that contains "{{page.title}} has class {{page.class}}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "My post has class kewl-post" in "_site/2016/01/21/my-post.html"

  Scenario: Previous and next posts title
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following posts:
      | title            | date       | layout  | author      | content                 |
      | Star Wars        | 2009-03-27 | ordered | Darth Vader | Luke, I am your father. |
      | Some like it hot | 2009-04-27 | ordered | Osgood      | Nobody is perfect.      |
      | Terminator       | 2009-05-27 | ordered | Arnold      | Sayonara, baby          |
    And I have a ordered layout that contains "Previous post: {{ page.previous.title }} and next post: {{ page.next.title }}"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "next post: Some like it hot" in "_site/2009/03/27/star-wars.html"
    And I should see "Previous post: Some like it hot" in "_site/2009/05/27/terminator.html"
