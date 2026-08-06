# frozen_string_literal: true

require "helper"

class TestThemeDataReader < JekyllUnitTest
  context "site without a theme" do
    setup do
      @site = fixture_site("theme" => nil)
      @site.reader.read_data
      assert @site.data["greetings"]
      assert @site.data["categories"]["dairy"]
    end

    should "should read data from source" do
      assert_equal "Hello! I’m foo. And who are you?", @site.data["greetings"]["foo"]
      assert_equal "Dairy", @site.data["categories"]["dairy"]["name"]
    end
  end

  context "site with a theme without _data" do
    setup do
      @site = fixture_site("theme" => "test-theme-skinny")
      @site.reader.read_data
      assert @site.data["greetings"]
      assert @site.data["categories"]["dairy"]
    end

    should "should read data from source" do
      assert_equal "Hello! I’m foo. And who are you?", @site.data["greetings"]["foo"]
      assert_equal "Dairy", @site.data["categories"]["dairy"]["name"]
    end
  end

  context "site with a theme with empty _data directory" do
    setup do
      @site = fixture_site("theme" => "test-theme-w-empty-data")
      @site.reader.read_data
      assert @site.data["greetings"]
      assert @site.data["categories"]["dairy"]
    end

    should "should read data from source" do
      assert_equal "Hello! I’m foo. And who are you?", @site.data["greetings"]["foo"]
      assert_equal "Dairy", @site.data["categories"]["dairy"]["name"]
    end
  end

  context "site with a theme with data at root of _data" do
    setup do
      @site = fixture_site("theme" => "test-theme")
      @site.reader.read_data
      assert @site.data["greetings"]
      assert @site.data["categories"]["dairy"]
      assert @site.data["cars"]
    end

    should "should merge nested keys" do
      refute_equal "Hello! I’m bar. What’s up so far?", @site.data["greetings"]["foo"]
      assert_equal "Hello! I’m foo. And who are you?", @site.data["greetings"]["foo"]
      assert_equal "Mercedes", @site.data["cars"]["manufacturer"]
    end
  end

  context "site with a theme with data at root of _data and in a subdirectory" do
    setup do
      @site = fixture_site("theme" => "test-theme")
      @site.reader.read_data
      assert @site.data["greetings"]
      assert @site.data["categories"]["dairy"]
      assert @site.data["cars"]
    end

    should "should merge nested keys" do
      refute_equal "Cheese Dairy", @site.data["categories"]["dairy"]["name"]
      expected_names = %w(cheese milk)
      product_names  = @site.data["categories"]["dairy"]["products"].map do |product|
        product["name"]
      end
      expected_names.each do |expected_name|
        assert_includes product_names, expected_name
      end
      assert_equal "Dairy", @site.data["categories"]["dairy"]["name"]
    end

    should "should illustrate the documented sample" do
      assert_equal "Kundenstimmen", @site.data["i18n"]["testimonials"]["header"]
      assert_equal "Design by FTC", @site.data["i18n"]["testimonials"]["footer"]
    end
  end

  context "site with a local theme with data" do
    setup do
      theme_data_dir = source_dir("_themes", "local-theme", "_data")
      FileUtils.mkdir_p(theme_data_dir)
      File.write(File.join(theme_data_dir, "cars.yml"), "manufacturer: Volvo\n")
      @site = fixture_site("theme" => "local-theme")
      @site.reader.read_data
    end

    teardown do
      FileUtils.rm_rf(source_dir("_themes"))
    end

    should "merge local theme data with source data" do
      assert_equal "Volvo", @site.data["cars"]["manufacturer"]
      assert_equal "Hello! I’m foo. And who are you?", @site.data["greetings"]["foo"]
    end
  end
end
