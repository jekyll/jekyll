Feature: Theme data
  As a hacker who likes to share my expertise
  I want to be able to embed data into my gemified theme
  In order to make the theme slightly dynamic

  Scenario: A theme with data files
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a "index.html" file with content:
    """
    ---
    ---
    {% assign menu = site.data.navigation %}
    {% for nav in menu.topnav %}
      <a href="{{ nav.url | relative_url }}">{{ nav.title | escape }}</a>
    {% endfor %}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "\n\n  <a href=\"/about/\">About</a>\n\n  <a href=\"/contact/\">Contact</a>\n" in "_site/index.html"

  Scenario: A site has other data files
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a _data directory
    And I have a "_data/reviews.yml" file with content:
    """
    docs:
    - title  : The Iron Throne
      url    : /iron-throne/
    - title  : Fire & Ice
      url    : /fire-n-ice/
    """
    And I have a "index.html" file with content:
    """
    ---
    ---
    {% assign mainmenu = site.data.navigation %}
    {% for nav in mainmenu.topnav %}
      <a href="{{ nav.url | relative_url }}">{{ nav.title | escape }}</a>
    {% endfor %}

    {% assign reviews = site.data.reviews %}
    {% for item in reviews.docs %}
      <a href="{{ item.url | relative_url }}">{{ item.title | escape }}</a>
    {% endfor %}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "\n\n  <a href=\"/about/\">About</a>\n\n  <a href=\"/contact/\">Contact</a>\n\n\n\n\n  <a href=\"/iron-throne/\">The Iron Throne</a>\n\n  <a href=\"/fire-n-ice/\">Fire &amp; Ice</a>\n" in "_site/index.html"

  Scenario: A site has a data file to override theme data
    Given I have a configuration file with "theme" set to "test-theme"
    And I have a _data directory
    And I have a "_data/navigation.yml" file with content:
    """
    topnav:
    - title  : About Krypton
      url    : /about/
    - title  : Smallville Diaries
      url    : /smallville/
    - title  : Contact Kal-El
      url    : /contact-us/
    """
    And I have a "index.html" file with content:
    """
    ---
    ---
    {% assign mainmenu = site.data.navigation %}
    {% for nav in mainmenu.topnav %}
      <a href="{{ nav.url | relative_url }}">{{ nav.title | escape }}</a>
    {% endfor %}
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "\n\n  <a href=\"/about/\">About Krypton</a>\n\n  <a href=\"/smallville/\">Smallville Diaries</a>\n\n  <a href=\"/contact-us/\">Contact Kal-El</a>\n" in "_site/index.html"
