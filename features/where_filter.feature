Feature: Testing the where filter

  Scenario: A page with various examples of filter usage
    Given I have a _data directory
    And I have a "_data/test.json" file with content:
    """
    [
      {
        "name": "one"
      },
      {
        "name": "two-with-dashes"
      },
      {
        "name": "three with spaces"
      },
      {
        "name": "four_with_underscore"
      },
      {
        "name": "five+with%special#characters"
      }
    ]
    """
    And I have an "filter.md" file with content:
    """
    ---
    ---
    {% assign one = site.data.test | where: "name", "one" %}
    one: {{ one }}<br>
    {% assign two = site.data.test | where: "name", "two-with-dashes" %}
    two: {{ two }}<br>
    {% assign three = site.data.test | where: "name", "three with spaces" %}
    three: {{ three }}<br>
    {% assign four = site.data.test | where: "name", "four_with_underscore" %}
    four: {{ four }}<br>
    {% assign five = site.data.test | where: "name", "five+with%special#characters" %}
    five: {{ five }}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "one" in "_site/filter.html"
    And I should see "two-with-dashes" in "_site/filter.html"
    And I should see "three with spaces" in "_site/filter.html"
    And I should see "four_with_underscore" in "_site/filter.html"
    And I should see "five\+with\%special\#characters" in "_site/filter.html"
