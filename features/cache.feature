Feature: Cache
  As a developer who likes to create plugins
  I want to be able to cache certain aspects across multiple builds
  And retrieve the cached aspects when needed

  Scenario: Default Cache directory
    Given I have an "index.md" page that contains "{{ site.title }}"
    And I have a configuration file with "title" set to "Hello World"
    When I run jekyll build
    Then I should get a zero exit status
    And the .jekyll-cache directory should exist
    And the .jekyll-cache/Jekyll/Cache/Jekyll--Cache directory should exist
    And the _site directory should exist
    And I should see "<p>Hello World</p>" in "_site/index.html"

  Scenario: Custom Cache directory
    Given I have an "index.md" page that contains "{{ site.title }}"
    And I have a configuration file with:
      | key       | value       |
      | title     | Hello World |
      | cache_dir | .foo-cache  |
    When I run jekyll build
    Then I should get a zero exit status
    And the .foo-cache directory should exist
    And the .foo-cache/Jekyll/Cache/Jekyll--Cache directory should exist
    But the .jekyll-cache directory should not exist
    And the _site directory should exist
    And I should see "<p>Hello World</p>" in "_site/index.html"

  Scenario: Disk usage in safe mode
    Given I have an "index.md" page that contains "{{ site.title }}"
    And I have a configuration file with "title" set to "Hello World"
    When I run jekyll build --safe
    Then I should get a zero exit status
    But the .jekyll-cache directory should not exist
    And the _site directory should exist
    And I should see "<p>Hello World</p>" in "_site/index.html"
