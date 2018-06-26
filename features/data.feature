Feature: Data
  In order to use well-formatted data in my blog
  As a blog's user
  I want to use _data directory in my site

  Scenario: autoload *.yaml files in _data directory
    Given I have a _data directory
    And I have a "_data/products.yaml" file with content:
      """
      - name: sugar
        price: 5.3
      - name: salt
        price: 2.5
      """
    And I have an "index.html" page that contains "{% for product in site.data.products %}{{product.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "sugar" in "_site/index.html"
    And I should see "salt" in "_site/index.html"

  Scenario: autoload *.yml files in _data directory
    Given I have a _data directory
    And I have a "_data/members.yml" file with content:
      """
      - name: Jack
        age: 28
      - name: Leon
        age: 34
      """
    And I have an "index.html" page that contains "{% for member in site.data.members %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"

  Scenario: autoload *.json files in _data directory
    Given I have a _data directory
    And I have a "_data/members.json" file with content:
      """
      [{"name": "Jack", "age": 28},{"name": "Leon", "age": 34}]
      """
    And I have an "index.html" page that contains "{% for member in site.data.members %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"

  Scenario: autoload *.csv files in _data directory
    Given I have a _data directory
    And I have a "_data/members.csv" file with content:
      """
      name,age
      Jack,28
      Leon,34
      """
    And I have an "index.html" page that contains "{% for member in site.data.members %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"

  Scenario: autoload *.tsv files in _data directory
    Given I have a _data directory
    And I have a "_data/members.tsv" file with content:
      """
      name	age
      Jack	28
      Leon	34
      """
    And I have an "index.html" page that contains "{% for member in site.data.members %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"

  Scenario: autoload *.yml files in _data directory with space in file name
    Given I have a _data directory
    And I have a "_data/team members.yml" file with content:
      """
      - name: Jack
        age: 28
      - name: Leon
        age: 34
      """
    And I have an "index.html" page that contains "{% for member in site.data.team_members %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"

  Scenario: autoload *.yaml files in subdirectories in _data directory
    Given I have a _data directory
    And I have a _data/categories directory
    And I have a "_data/categories/dairy.yaml" file with content:
      """
      name: Dairy Products
      """
    And I have an "index.html" page that contains "{{ site.data.categories.dairy.name }}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Dairy Products" in "_site/index.html"

  Scenario: folders should have precedence over files with the same name
    Given I have a _data directory
    And I have a _data/categories directory
    And I have a "_data/categories/dairy.yaml" file with content:
      """
      name: Dairy Products
      """
    And I have a "_data/categories.yaml" file with content:
      """
      dairy:
        name: Should not display this
      """
    And I have an "index.html" page that contains "{{ site.data.categories.dairy.name }}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Dairy Products" in "_site/index.html"

  Scenario: should be backward compatible with site.data in _config.yml
    Given I have a "_config.yml" file with content:
      """
      data:
        - name: Jack
          age: 28
        - name: Leon
          age: 34
      """
    And I have an "index.html" page that contains "{% for member in site.data %}{{member.name}}{% endfor %}"
    When I run jekyll build
    Then the "_site/index.html" file should exist
    And I should see "Jack" in "_site/index.html"
    And I should see "Leon" in "_site/index.html"
