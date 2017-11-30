# frozen_string_literal: true

require "helper"

class TestPageWithoutAFile < JekyllUnitTest
  def setup_page(*args, base: source_dir, klass: PageWithoutAFile)
    dir, file = args
    if file.nil?
      file = dir
      dir = ""
    end
    klass.new(@site, base, dir, file)
  end

  context "A PageWithoutAFile" do
    setup do
      clear_dest
      @site = Site.new(Jekyll.configuration({
        "source"            => source_dir,
        "destination"       => dest_dir,
        "skip_config_files" => true,
      }))
    end

    context "with default site configuration" do
      setup do
        @page = setup_page("properties.html")
      end

      should "not have page-content and page-data defined within it" do
        assert_equal "pages", @page.type.to_s
        assert_nil @page.content
        assert_empty @page.data
      end

      should "have basic attributes defined in it" do
        regular_page = setup_page("properties.html", :klass => Page)
        basic_attrs = %w(dir name path url)
        attrs = {
          "content"   => "All the properties.\n",
          "dir"       => "/",
          "excerpt"   => nil,
          "foo"       => "bar",
          "layout"    => "default",
          "name"      => "properties.html",
          "path"      => "properties.html",
          "permalink" => "/properties/",
          "published" => nil,
          "title"     => "Properties Page",
          "url"       => "/properties.html",
        }
        attrs.each do |prop, value|
          # assert the props being accessible in a Jekyll::Page instance
          assert_equal "All the properties.\n", regular_page["content"]
          assert_equal "properties.html", regular_page["name"]

          # assert differences with Jekyll::PageWithoutAFile instance
          if basic_attrs.include?(prop)
            assert_equal @page[prop], value, "For <page[\"#{prop}\"]>:"
          else
            assert_nil @page[prop]
          end
        end
      end
    end

    context "with site-wide permalink configuration" do
      setup do
        @site.permalink_style = :title
      end

      should "generate page url accordingly" do
        page = setup_page("properties.html")
        assert_equal "/properties", page.url
      end
    end

    context "with default front matter configuration" do
      setup do
        @site.config["defaults"] = [
          {
            "scope"  => {
              "path" => "",
              "type" => "pages",
            },
            "values" => {
              "layout" => "default",
              "author" => "John Doe",
            },
          },
        ]

        @page = setup_page("info.md")
      end

      should "respect front matter defaults" do
        assert_nil @page.data["title"]
        assert_equal "John Doe", @page.data["author"]
        assert_equal "default", @page.data["layout"]
      end
    end

    context "with a path outside site.source" do
      should "not access its contents" do
        base = "../../../"
        page = setup_page("pwd", :base => base)

        assert_equal "pwd", page.path
        assert_nil page.content
      end
    end

    context "while processing" do
      should "recieve content provided to it" do
        page = setup_page("properties.html")
        assert_nil page.content

        page.content = "{{ site.title }}"
        assert_equal "{{ site.title }}", page.content
      end
    end
  end
end
