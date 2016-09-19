Feature: Building Theme Gems
  As a hacker who likes to share my expertise
  I want to be able to make a bonafide rubygem off my theme
  In order to share my awesome style skillz with other Jekyllites

  Scenario: Generating a new Jekyll Theme
    When I run jekyll new-theme my-cool-theme
    Then I should get a zero exit status
    And the my-cool-theme directory should exist

  Scenario: Checking if a bonafide Theme gem will be built from generated scaffolding
    When I run jekyll new-theme my-cool-theme
    Then I should get a zero exit status
    And the my-cool-theme directory should exist
    When I decide to build the theme gem
    Then I should get a zero exit status
    When I run git add .
    Then I should get a zero exit status
    When I run gem build my-cool-theme.gemspec
    Then I should get a zero exit status
    And the "./my-cool-theme-0.1.0.gem" file should exist
    When I run gem unpack my-cool-theme-0.1.0.gem
    Then I should get a zero exit status
    And the my-cool-theme-0.1.0 directory should exist
    And the "my-cool-theme-0.1.0/_layouts/default.html" file should exist
    And the "my-cool-theme-0.1.0/_includes/blank.html" file should exist
    And the "my-cool-theme-0.1.0/_sass/blank.scss" file should exist
    And the my-cool-theme-0.1.0/.git directory should not exist
    And the "my-cool-theme-0.1.0/.gitignore" file should not exist
    And the "my-cool-theme-0.1.0/Gemfile" file should not exist
    And the "my-cool-theme-0.1.0/my-cool-theme.gemspec" file should not exist
