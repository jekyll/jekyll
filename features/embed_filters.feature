Feature: Embed filters
  As a hacker who likes to blog
  I want to be able to transform text inside a post or page
  In order to perform cool stuff in my posts

  Scenario: Convert date to XML schema
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                     |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ site.time | date_to_xmlschema }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see today's date in "_site/2009/03/27/star-wars.html"

  Scenario: Escape text for XML
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title       | date      | layout  | content                                     |
      | Star & Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ page.title | xml_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Star &amp; Wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Calculate number of words
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                     |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ content | xml_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "7" in "_site/2009/03/27/star-wars.html"

  Scenario: Convert an array into a sentence
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | tags                   | content                                     |
      | Star Wars | 3/27/2009 | default | [scifi, movies, force] | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ page.tags | array_to_sentence_string }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "scifi, movies, and force" in "_site/2009/03/27/star-wars.html"

  Scenario: Textilize a given string
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                      |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "By {{ '_Obi-wan_' | textilize }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "By <p><em>Obi-wan</em></p>" in "_site/2009/03/27/star-wars.html"

