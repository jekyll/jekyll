Feature: Embed filters
  As a hacker who likes to blog
  I want to be able to transform text inside a post or page
  In order to perform cool stuff in my posts

  Scenario: Convert date to XML schema
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Date to XML schema" for "3/26/2009" that contains "{{ post.date | date_to_xmlschema }}"
    When I run jekyll
    Then the _site directory should exist
    And the _site/2009/03/26/date-to-xml-schema.html file should exist
    And I should see "2009-03-26T00:00:00-08:00" in "_site/2009/03/26/date-to-xml-schema.html"

  Scenario: Escape text for XML
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Escape text for XML" for "3/26/2009" that contains "{{ '<tt>Mario & Luigi</tt>' | xml_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "&lt;tt&gt;Mario &amp; Luigi&lt;tt&gt;" in "_site/2009/03/26/escape-text-for-xml.html"

  Scenario: Calculate number of words
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Calculate number of words" for "3/26/2009" that contains "{{ post.title | number_of_words }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "4" in "_site/2009/03/26/calculate-number-of-words.html"

  Scenario: Convert an array into a sentence
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Convert array to sentence" for "3/26/2009" with that contains "{{ post.tags | array_to_sentence_string }}"
    And I have a post titled "Convert array to sentence" for "3/26/2009" with tags "life hacks code"
    When I run jekyll
    Then the _site directory should exist
    And I should see "life, hacks, and code" in "_site/2009/03/26/convert-array-to-sentence.html"

  Scenario: Textilize a given string
    Given I have a blank site
    And I have a _posts directory
    And I have a post titled "Textilize" for "3/26/2009" with that contains "{{ post.author | textilize }}"
    And I have a post titled "Textilize" for "3/26/2009" with author "*Mr. Spock*"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<b>Mr. Spock</b>" in "_site/2009/03/26/textilize.html"
