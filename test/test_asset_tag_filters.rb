require "helper"

class TestAssetTagFilters < JekyllUnitTest
  class JekyllTagFilter
    include Jekyll::Filters
    include Jekyll::Filters::AssetTagFilters
    attr_accessor :site, :context

    def initialize(opts = {})
      @site = Jekyll::Site.new(opts.merge("skip_config_files" => true))
      @context = Liquid::Context.new({}, {}, { :site => @site })
    end
  end

  def setup
    @filter = make_filter_mock({
      "url"     => "http://example.com",
      "baseurl" => "/base"
    })
    @image_file = "logo.png"
    @stylesheet = "main.css"
    @script_file = "script.js"
  end

  def make_filter_mock(opts = {})
    JekyllTagFilter.new(site_configuration(opts))
  end

  # asset tag filter is the collective term for image_tag, stylesheet_tag, and
  # script_tag filters.
  context "asset tag filter" do
    should "generate the HTML tag for a given asset file" do
      assert_equal(
        "<img src='#{@image_file}' alt=''>",
        @filter.image_tag(@image_file)
      )
      assert_equal(
        "<link rel='stylesheet' href='#{@stylesheet}'>",
        @filter.stylesheet_tag(@stylesheet)
      )
      assert_equal(
        "<script src='#{@script_file}'></script>",
        @filter.script_tag(@script_file)
      )
    end
  end

  context "asset tag filter with relative_url filter" do
    should "generate the HTML tag with relative url for a given asset file" do
      assert_equal(
        "<img src='/base/#{@image_file}' alt=''>",
        @filter.image_tag(
          @filter.relative_url(@image_file)
        )
      )
      assert_equal(
        "<link rel='stylesheet' href='/base/#{@stylesheet}'>",
        @filter.stylesheet_tag(
          @filter.relative_url(@stylesheet)
        )
      )
      assert_equal(
        "<script src='/base/#{@script_file}'></script>",
        @filter.script_tag(
          @filter.relative_url(@script_file)
        )
      )
    end
  end

  context "asset tag filter with absolute_url filter" do
    should "generate the HTML tag with relative url for a given asset file" do
      assert_equal(
        "<img src='http://example.com/base/#{@image_file}' alt=''>",
        @filter.image_tag(
          @filter.absolute_url(@image_file)
        )
      )
      assert_equal(
        "<link rel='stylesheet' href='http://example.com/base/#{@stylesheet}'>",
        @filter.stylesheet_tag(
          @filter.absolute_url(@stylesheet)
        )
      )
      assert_equal(
        "<script src='http://example.com/base/#{@script_file}'></script>",
        @filter.script_tag(
          @filter.absolute_url(@script_file)
        )
      )
    end
  end

  context "image_tag filter with additional parameters" do
    should "generate the <img/> tag with optional attributes" do
      instance = @filter.image_tag(@image_file, "test-image", 72, "test logo")
      default_output = "<img src='#{@image_file}' alt=''>"
      custom_output = "<img src='logo.png' alt='test-image' width='72' " \
                      "height='auto' class='test logo'>"
      assert_equal custom_output, instance
      refute_equal default_output, instance
    end

    should "generate the <img/> tag with provided optional attributes only" do
      filter_instance = @filter.image_tag(@image_file, "test-image", 72)
      output = "<img src='logo.png' alt='test-image' width='72' height='auto'>"
      output_with_classname = "<img src='#{@image_file}' width='72' height='60' " \
                              "alt='test-image' class=''/>"
      assert_equal output, filter_instance
      refute_equal output_with_classname, filter_instance
    end
  end
end
