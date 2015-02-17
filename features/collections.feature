Feature: Collections
  As a hacker who likes to structure content
  I want to be able to create collections of similar information
  And render them

  Scenario: Unrendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.methods }}"
    And I have fixture collections
    And I have a configuration file with "collections" set to "['methods']"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: <p>Use <code>Jekyll.configuration</code> to build a full configuration for use w/Jekyll.</p>\n\n<p>Whatever: foo.bar</p>\n<p>Signs are nice</p>\n<p><code>Jekyll.sanitized_path</code> is used to make sure your path is in your source.</p>\n<p>Run your generators! default</p>\n<p>Page without title.</p>\n<p>Run your generators! default</p>" in "_site/index.html"
    And the "_site/methods/configuration.html" file should not exist

  Scenario: Rendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have an "collection_metadata.html" page that contains "Methods metadata: {{ site.collections.methods.foo }} {{ site.collections.methods }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        foo:   bar
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: {\"methods" in "_site/index.html"
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
    Then the _site directory should exist
    And I should see "<p>Whatever: foo.bar</p>" in "_site/methods/configuration/index.html"

  Scenario: Rendered document in a layout
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
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
    Then the _site directory should exist
    And I should see "Collections: {\"methods" in "_site/index.html"
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
    Then the _site directory should exist
    And I should see "Collections: _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html"

  Scenario: Collections specified as an hash
    Given I have an "index.html" page that contains "Collections: {% for method in site.methods %}{{ method.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html"

  Scenario: All the documents
    Given I have an "index.html" page that contains "All documents: {% for doc in site.documents %}{{ doc.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "All documents: _methods/configuration.md _methods/escape-\+ #%20\[\].md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html"

  Scenario: Documents have an output attribute, which is the converted HTML
    Given I have an "index.html" page that contains "First document's output: {{ site.documents.first.output }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "First document's output: <p>Use <code>Jekyll.configuration</code> to build a full configuration for use w/Jekyll.</p>\n\n<p>Whatever: foo.bar</p>" in "_site/index.html"

  Scenario: Filter documents by where
    Given I have an "index.html" page that contains "{% assign items = site.methods | where: 'whatever','foo.bar' %}Item count: {{ items.size }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Item count: 2" in "_site/index.html"

  Scenario: Sort by title
    Given I have an "index.html" page that contains "{% assign items = site.methods | sort: 'title' %}1. of {{ items.size }}: {{ items.first.output }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "1. of 7: <p>Page without title.</p>" in "_site/index.html"

  Scenario: Sort by relative_path
    Given I have an "index.html" page that contains "Collections: {% assign methods = site.methods | sort: 'relative_path' %}{% for method in methods %}{{ method.title }}, {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: Jekyll.configuration, Jekyll.escape, Jekyll.sanitized_path, Site#generate, , Site#generate," in "_site/index.html"
