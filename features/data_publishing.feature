Feature: Data
  In order to publish raw data along with my site
  As a blog's user
  I want to publish the contents of the _data directory in raw format

  Background:
    Given I have a _data directory
    And I have a "_data/products.yaml" file with content:
      """
      - name: sugar
        price: 5.3
      - name: salt
        price: 2.5
      """  

  Scenario: Do not publish data files if config var is missing
    When I run jekyll build
    Then the "data/products.yaml" file should not exist
  
  Scenario: Publish all files from _data directory if config var is set
    Given I have a "_config.yml" file with content:
      """
      data_target: data
      """
    When I run jekyll build
    Then the "data/products.yaml" file should exist
    And I should see "sugar" in "data/products.yaml"
    And I should see "salt" in "data/products.yaml"