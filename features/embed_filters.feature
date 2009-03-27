Feature: Embed filters
  As a hacker who likes to blog
  I want to be able to transform text inside a post or page
  In order to perform cool stuff in my posts

  Scenario: Convert date to XML schema
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title              | date      | content                             |
      | Date to XML schema | 3/27/2009 | {{ post.date | date_to_xmlschema }} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "2009-03-27T00:00:00-08:00" in "_site/2009/03/27/date-to-xml-schema.html"

  Scenario: Escape text for XML
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title               | date      | content                                     |
      | Escape text for XML | 3/27/2009 | {{ '<tt>Mario & Luigi</tt>' | xml_escape }} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "&lt;tt&gt;Mario &amp; Luigi&lt;tt&gt;" in "_site/2009/03/27/escape-text-for-xml.html"

  Scenario: Calculate number of words
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title                     | date      | content                            |
      | Calculate number of words | 3/27/2009 | {{ post.title | number_of_words }} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "4" in "_site/2009/03/27/calculate-number-of-words.html"

  Scenario: Convert an array into a sentence
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title                     | date      | tags            | content                                    |
      | Convert array to sentence | 3/27/2009 | life hacks code | {{ post.tags | array_to_sentence_string }} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "life, hacks, and code" in "_site/2009/03/27/convert-array-to-sentence.html"

  Scenario: Textilize a given string
    Given I have a blank site
    And I have a _posts directory
    And I have the following post:
      | title           | date      | tags        | content                       |
      | Logical Awesome | 3/27/2009 | *Mr. Spock* | {{ post.author | textilize }} |
    When I run jekyll
    Then the _site directory should exist
    And I should see "<b>Mr. Spock</b>" in "_site/2009/03/27/textilize.html"

