Feature: Collections
  As a hacker who likes to structure content
  I want to be able to create collections of similar information
  And render them

  Scenario: Unrendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.methods }}"
    And I have fixture collections
    And I have a configuration file with "collections" set to "['methods']"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/methods/configuration.html" file should not exist

  Scenario: Rendered collection
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }}"
    And I have an "collection_metadata.html" page that contains "Methods metadata: {{ site.collections[0].foo }} {{ site.collections[0] }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        foo:   bar
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Collections: output => true" in "_site/index.html"
    And I should see "label => methods" in "_site/index.html"
    And I should see "Methods metadata: bar" in "_site/collection_metadata.html"
    And I should see "<p>Whatever: foo.bar</p>" in "_site/methods/configuration.html"

  Scenario: Rendered collection at a custom URL
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        permalink: /:collection/:path/
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "<p>Whatever: foo.bar</p>" in "_site/methods/configuration/index.html"

  Scenario: Rendered document in a layout
    Given I have an "index.html" page that contains "Collections: output => {{ site.collections[0].output }} label => {{ site.collections[0].label }} foo => {{ site.collections[0].foo }}"
    And I have a default layout that contains "<div class='title'>Tom Preston-Werner</div> {{content}}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        foo:   bar
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Collections: output => true" in "_site/index.html"
    And I should see "label => methods" in "_site/index.html"
    And I should see "foo => bar" in "_site/index.html"
    And I should see "<p>Run your generators! default</p>" in "_site/methods/site/generate.html"
    And I should see "<div class='title'>Tom Preston-Werner</div>" in "_site/methods/site/generate.html"

  Scenario: Collections specified as an array
    Given I have an "index.html" page that contains "Collections: {% for method in site.methods %}{{ method.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    Then the _site directory should exist
    And I should see "Collections: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html" unless Windows
    And I should see "Collections: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/yaml_with_dots.md" in "_site/index.html" if on Windows

  Scenario: Collections specified as an hash
    Given I have an "index.html" page that contains "Collections: {% for method in site.methods %}{{ method.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    Then the _site directory should exist
    And I should see "Collections: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html" unless Windows
    And I should see "Collections: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/yaml_with_dots.md" in "_site/index.html" if on Windows

  Scenario: Rendered collection with document with future date
    Given I have a _puppies directory
    And I have the following documents under the puppies collection:
      | title  | date       | content             |
      | Rover  | 2007-12-31 | content for Rover.  |
      | Fido   | 2120-12-31 | content for Fido.   |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: true
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "content for Rover" in "_site/puppies/rover.html"
    And the "_site/puppies/fido.html" file should not exist
    When I run jekyll build --future
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/fido.html" file should exist

  Scenario: Hidden collection with document with future date
    Given I have a _puppies directory
    And I have the following documents under the puppies collection:
      | title  | date       | content             |
      | Rover  | 2007-12-31 | content for Rover.  |
      | Fido   | 2120-12-31 | content for Fido.   |
    And I have a "_config.yml" file with content:
    """
    collections:
      puppies:
        output: false
    """
    And I have a "foo.txt" file that contains "random static file"
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/rover.html" file should not exist
    And the "_site/puppies/fido.html" file should not exist
    When I run jekyll build --future
    Then I should get a zero exit status
    And the _site directory should exist
    And the "_site/puppies/fido.html" file should not exist

  Scenario: All the documents
    Given I have an "index.html" page that contains "All documents: {% for doc in site.documents %}{{ doc.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    Then the _site directory should exist
    And I should see "All documents: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html" unless Windows
    And I should see "All documents: _methods/3940394-21-9393050-fifif1323-test.md _methods/collection/entries _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/yaml_with_dots.md" in "_site/index.html" if on Windows

  Scenario: Documents have an output attribute, which is the converted HTML
    Given I have an "index.html" page that contains "Second document's output: {{ site.documents[2].output }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    Then the _site directory should exist
    And I should see "Second document's output: <p>Use <code class=\"highlighter-rouge\">Jekyll.configuration</code> to build a full configuration for use w/Jekyll.</p>\n\n<p>Whatever: foo.bar</p>" in "_site/index.html"

  Scenario: Filter documents by where
    Given I have an "index.html" page that contains "{% assign items = site.methods | where: 'whatever','foo.bar' %}Item count: {{ items.size }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Item count: 2" in "_site/index.html"

  Scenario: Sort by title
    Given I have an "index.html" page that contains "{% assign items = site.methods | sort: 'title' %}2. of {{ items.size }}: {{ items[1].output }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "2. of 9: <p>Page without title.</p>" in "_site/index.html" unless Windows
    And I should see "2. of 8: <p>Page without title.</p>" in "_site/index.html" if on Windows

  Scenario: Sort by relative_path
    Given I have an "index.html" page that contains "Collections: {% assign methods = site.methods | sort: 'relative_path' %}{{ methods | map:"title" | join: ", " }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then I should get a zero exit status
    Then the _site directory should exist
    And I should see "Collections: this is a test!, Collection#entries, Jekyll.configuration, Jekyll.escape, Jekyll.sanitized_path, Site#generate, Initialize, Site#generate, YAML with Dots" in "_site/index.html" unless Windows
    And I should see "Collections: this is a test!, Collection#entries, Jekyll.configuration, Jekyll.escape, Jekyll.sanitized_path, Site#generate, Initialize, YAML with Dots" in "_site/index.html" if on Windows

  Scenario: Rendered collection with date/dateless filename
    Given I have an "index.html" page that contains "Collections: {% for method in site.thanksgiving %}{{ method.title }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      thanksgiving:
        output: true
    """
    When I run jekyll build
    Then I should get a zero exit status
    And the _site directory should exist
    And I should see "Thanksgiving Black Friday" in "_site/index.html"
    And I should see "Happy Thanksgiving" in "_site/thanksgiving/2015-11-26-thanksgiving.html"
    And I should see "Black Friday" in "_site/thanksgiving/black-friday.html"
