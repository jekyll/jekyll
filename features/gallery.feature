Feature: Image galleries
  As a photographer who likes to hack
  I want to be able to make image galleries
  In order to share my awesome photos with the interwebs

  Scenario: Images stored in sourcedir
    Given I have a "20110310-foo-bar.jpg" file that contains " "
    And I have a "20110311-slug.jpg" file that contains " "
    And I have an "index.html" page that contains "{% gallery dir:. %}{{ file.url }} {% endgallery %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "/20110311-slug.jpg /20110310-foo-bar.jpg" in "_site/index.html"

  Scenario: Images in subdir
    Given I have an img directory
    And I have an "img/20110310-foo-bar.jpg" file that contains " "
    And I have an "img/20110311-slug.jpg" file that contains " "
    And I have an "index.html" page that contains "{% gallery %}{{ file.path }} {% endgallery %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "img/20110311-slug.jpg img/20110310-foo-bar.jpg" in "_site/index.html"

  Scenario: I want to have more than one distinct gallery on my site
    Given I have a europe directory
    And I have a europe/img directory
    And I have a "europe/img/20110310-london-england.jpg" file that contains " "
    And I have a "europe/img/20110311-paris-france.jpg" file that contains " "
    And I have a "europe/img/20110312-berlin-germany.jpg" file that contains " "
    And I have a "europe/index.html" page that contains "{% gallery name:europe reverse:no %}{{ file.title }}. {% endgallery %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "London England. Paris France. Berlin Germany." in "_site/europe/index.html"

  Scenario: I want to show a list of files to download instead of images
    Given I have a downloads directory
    And I have a downloads/files directory
    And I have a "downloads/files/example-0.1.1.tar.gz" file that contains " "
    And I have a "downloads/files/example-0.2.0.tar.gz" file that contains " "
    And I have a "downloads/index.html" page that contains "{% gallery name:downloads dir:files format:tar.gz %}{{ file.slug }} {% endgallery %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "example-0.2.0 example-0.1.1" in "_site/downloads/index.html"

  Scenario: I want to show a list of documents that incorporate YAML Front Matter
    Given I have a documentation directory
    And I have a "documentation/introduction.textile" page with layout "chazwozzer" that contains "_Welcome!_"
    And I have an "index.html" page that contains "{% gallery dir:documentation format:textile %}{{ file.htmlpath }} {{ file.layout }}{% endgallery %}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "<em>Welcome!</em>" in "_site/documentation/introduction.html"
    And I should see "documentation/introduction.html chazwozzer" in "_site/index.html"
