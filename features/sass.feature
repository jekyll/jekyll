Feature: Sass
  As a mega hacker who likes to blog
  I want to use variables, nested selectors and other goodies in my stylesheets
  So I prefer to use Sass

  Scenario: Simple converting
    Given I have a css directory
    And I have a "css/style.scss" file that contains:
    """
    ---
    ---
    $main-color: #ce4dd6;
    #footer {
      .odd {color: $main-color;}
      .even {color: lighten($main-color, 20%);}
    }
    """
    When I run jekyll
    Then I should see "#footer .odd\{color:#ce4dd6\}#footer .even\{color:#e5a0e9\}" in "_site/css/style.css"

  Scenario: Importing
    Given I have a css directory
    And I have a css/in directory
    And I have a "css/style.scss" file that contains:
    """
    ---
    ---
    @import "rounded";
    @import "in/another";
    """
    And I have a "css/_rounded.scss" file that contains:
    """
    .rounded {border-top-radius: 10px;}
    """
    And I have a "css/in/_another.scss" file that contains:
    """
    h1 {color: #ce4dd6;}
    """
    When I run jekyll
    Then I should see ".rounded\{border-top-radius:10px\}h1\{color:#ce4dd6\}" in "_site/css/style.css"
    And the "_site/css/rounded.css" file should not exist
    And the "_site/css/in" directory should not exist

  Scenario: Basic Compass using
    Given I have a css directory
    And I have a "css/style.scss" file that contains:
    """
    ---
    ---
    @import "compass/css3/border-radius";
    .simple   { @include border-radius(4px, 4px); }
    """
    When I run jekyll
    Then I should see "-moz-border-radius:4px / 4px;" in "_site/css/style.css"

  Scenario: Security issue
    Given I have a css directory
    And I have a "css/style.scss" file that contains:
    """
    ---
    ---
    p {
      @if require('fileutils') && FileUtils.rm('/tmp/jekyll/log.txt') == true {
        border: 1px solid;
      }
    }
    """
    And I have a "log.txt" file that contains "I want to live!"
    When I run jekyll
    Then the "log.txt" file should exist
    And I should see "@if require\('fileutils'\)" in "_site/css/style.css"

  Scenario: Preventing CPU overload
    Given I have a css directory
    And I have a "css/style.scss" file that contains:
    """
    ---
    ---
    $i: 0;
    @while $i == 0 {
      .item-#{$i} { width: 2em * $i; }
    }
    """
    When I run jekyll
    And I should see "@while \$i == 0 \{" in "_site/css/style.css"