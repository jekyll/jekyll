# frozen_string_literal: true

require "helper"

class TestFilters < JekyllUnitTest
  class JekyllFilter
    include Jekyll::Filters
    attr_accessor :site, :context

    def initialize(opts = {})
      @site = Jekyll::Site.new(opts.merge("skip_config_files" => true))
      @context = Liquid::Context.new(@site.site_payload, {}, { :site => @site })
    end
  end

  class Value
    def initialize(value)
      @value = value
    end

    def to_s
      @value.respond_to?(:call) ? @value.call : @value.to_s
    end
  end

  def make_filter_mock(opts = {})
    JekyllFilter.new(site_configuration(opts)).tap do |f|
      tz = f.site.config["timezone"]
      Jekyll.set_timezone(tz) if tz
    end
  end

  class SelectDummy
    def select; end
  end

  context "filters" do
    setup do
      @sample_time = Time.utc(2013, 3, 27, 11, 22, 33)
      @filter = make_filter_mock({
        "timezone"               => "UTC",
        "url"                    => "http://example.com",
        "baseurl"                => "/base",
        "dont_show_posts_before" => @sample_time,
      })
      @sample_date = Date.parse("2013-03-27")
      @time_as_string = "September 11, 2001 12:46:30 -0000"
      @time_as_numeric = 1_399_680_607
      @integer_as_string = "142857"
      @array_of_objects = [
        { "color" => "red",  "size" => "large"  },
        { "color" => "red",  "size" => "medium" },
        { "color" => "blue", "size" => "medium" },
      ]
    end

    should "markdownify with simple string" do
      assert_equal(
        "<p>something <strong>really</strong> simple</p>\n",
        @filter.markdownify("something **really** simple")
      )
    end

    should "markdownify with a number" do
      assert_equal(
        "<p>404</p>\n",
        @filter.markdownify(404)
      )
    end

    context "smartify filter" do
      should "convert quotes and typographic characters" do
        assert_equal(
          "SmartyPants is *not* Markdown",
          @filter.smartify("SmartyPants is *not* Markdown")
        )
        assert_equal(
          "“This filter’s test…”",
          @filter.smartify(%q{"This filter's test..."})
        )
      end

      should "convert not convert markdown to block HTML elements" do
        assert_equal(
          "#hashtag", # NOT "<h1>hashtag</h1>"
          @filter.smartify("#hashtag")
        )
      end

      should "escapes special characters when configured to do so" do
        kramdown = make_filter_mock({ :kramdown => { :entity_output => :symbolic } })
        assert_equal(
          "&ldquo;This filter&rsquo;s test&hellip;&rdquo;",
          kramdown.smartify(%q{"This filter's test..."})
        )
      end

      should "convert HTML entities to unicode characters" do
        assert_equal "’", @filter.smartify("&rsquo;")
        assert_equal "“", @filter.smartify("&ldquo;")
      end

      should "convert multiple lines" do
        assert_equal "…\n…", @filter.smartify("...\n...")
      end

      should "allow raw HTML passthrough" do
        assert_equal(
          "Span HTML is <em>not</em> escaped",
          @filter.smartify("Span HTML is <em>not</em> escaped")
        )
        assert_equal(
          "<div>Block HTML is not escaped</div>",
          @filter.smartify("<div>Block HTML is not escaped</div>")
        )
      end

      should "escape special characters" do
        assert_equal "3 &lt; 4", @filter.smartify("3 < 4")
        assert_equal "5 &gt; 4", @filter.smartify("5 > 4")
        assert_equal "This &amp; that", @filter.smartify("This & that")
      end

      should "convert a number to a string" do
        assert_equal(
          "404",
          @filter.smartify(404)
        )
      end

      should "not output any warnings" do
        assert_empty(
          capture_output { @filter.smartify("Test") }
        )
      end
    end

    should "sassify with simple string" do
      assert_equal(
        "p {\n  color: #123456; }\n",
        @filter.sassify("$blue:#123456\np\n  color: $blue")
      )
    end

    should "scssify with simple string" do
      assert_equal(
        "p {\n  color: #123456; }\n",
        @filter.scssify("$blue:#123456; p{color: $blue}")
      )
    end

    should "convert array to sentence string with no args" do
      assert_equal "", @filter.array_to_sentence_string([])
    end

    should "convert array to sentence string with one arg" do
      assert_equal "1", @filter.array_to_sentence_string([1])
      assert_equal "chunky", @filter.array_to_sentence_string(["chunky"])
    end

    should "convert array to sentence string with two args" do
      assert_equal "1 and 2", @filter.array_to_sentence_string([1, 2])
      assert_equal "chunky and bacon", @filter.array_to_sentence_string(%w(chunky bacon))
    end

    should "convert array to sentence string with multiple args" do
      assert_equal "1, 2, 3, and 4", @filter.array_to_sentence_string([1, 2, 3, 4])
      assert_equal(
        "chunky, bacon, bits, and pieces",
        @filter.array_to_sentence_string(%w(chunky bacon bits pieces))
      )
    end

    should "convert array to sentence string with different connector" do
      assert_equal "1 or 2", @filter.array_to_sentence_string([1, 2], "or")
      assert_equal "1, 2, 3, or 4", @filter.array_to_sentence_string([1, 2, 3, 4], "or")
    end

    context "normalize_whitespace filter" do
      should "replace newlines with a space" do
        assert_equal "a b", @filter.normalize_whitespace("a\nb")
        assert_equal "a b", @filter.normalize_whitespace("a\n\nb")
      end

      should "replace tabs with a space" do
        assert_equal "a b", @filter.normalize_whitespace("a\tb")
        assert_equal "a b", @filter.normalize_whitespace("a\t\tb")
      end

      should "replace multiple spaces with a single space" do
        assert_equal "a b", @filter.normalize_whitespace("a  b")
        assert_equal "a b", @filter.normalize_whitespace("a\t\nb")
        assert_equal "a b", @filter.normalize_whitespace("a \t \n\nb")
      end

      should "strip whitespace from beginning and end of string" do
        assert_equal "a", @filter.normalize_whitespace("a ")
        assert_equal "a", @filter.normalize_whitespace(" a")
        assert_equal "a", @filter.normalize_whitespace(" a ")
      end
    end

    context "date filters" do
      context "with Time object" do
        should "format a date with short format" do
          assert_equal "27 Mar 2013", @filter.date_to_string(@sample_time)
        end

        should "format a date with long format" do
          assert_equal "27 March 2013", @filter.date_to_long_string(@sample_time)
        end

        should "format a time with xmlschema" do
          assert_equal(
            "2013-03-27T11:22:33+00:00",
            @filter.date_to_xmlschema(@sample_time)
          )
        end

        should "format a time according to RFC-822" do
          assert_equal(
            "Wed, 27 Mar 2013 11:22:33 +0000",
            @filter.date_to_rfc822(@sample_time)
          )
        end

        should "not modify a time in-place when using filters" do
          t = Time.new(2004, 9, 15, 0, 2, 37, "+01:00")
          assert_equal 3600, t.utc_offset
          @filter.date_to_string(t)
          assert_equal 3600, t.utc_offset
        end
      end

      context "with Date object" do
        should "format a date with short format" do
          assert_equal "27 Mar 2013", @filter.date_to_string(@sample_date)
        end

        should "format a date with long format" do
          assert_equal "27 March 2013", @filter.date_to_long_string(@sample_date)
        end

        should "format a time with xmlschema" do
          assert_equal(
            "2013-03-27T00:00:00+00:00",
            @filter.date_to_xmlschema(@sample_date)
          )
        end

        should "format a time according to RFC-822" do
          assert_equal(
            "Wed, 27 Mar 2013 00:00:00 +0000",
            @filter.date_to_rfc822(@sample_date)
          )
        end
      end

      context "with String object" do
        should "format a date with short format" do
          assert_equal "11 Sep 2001", @filter.date_to_string(@time_as_string)
        end

        should "format a date with long format" do
          assert_equal "11 September 2001", @filter.date_to_long_string(@time_as_string)
        end

        should "format a time with xmlschema" do
          assert_equal(
            "2001-09-11T12:46:30+00:00",
            @filter.date_to_xmlschema(@time_as_string)
          )
        end

        should "format a time according to RFC-822" do
          assert_equal(
            "Tue, 11 Sep 2001 12:46:30 +0000",
            @filter.date_to_rfc822(@time_as_string)
          )
        end

        should "convert a String to Integer" do
          assert_equal(
            142_857,
            @filter.to_integer(@integer_as_string)
          )
        end
      end

      context "with a Numeric object" do
        should "format a date with short format" do
          assert_equal "10 May 2014", @filter.date_to_string(@time_as_numeric)
        end

        should "format a date with long format" do
          assert_equal "10 May 2014", @filter.date_to_long_string(@time_as_numeric)
        end

        should "format a time with xmlschema" do
          assert_match(
            "2014-05-10T00:10:07",
            @filter.date_to_xmlschema(@time_as_numeric)
          )
        end

        should "format a time according to RFC-822" do
          assert_equal(
            "Sat, 10 May 2014 00:10:07 +0000",
            @filter.date_to_rfc822(@time_as_numeric)
          )
        end
      end

      context "without input" do
        should "return input" do
          assert_nil(@filter.date_to_xmlschema(nil))
          assert_equal("", @filter.date_to_xmlschema(""))
        end
      end
    end

    should "escape xml with ampersands" do
      assert_equal "AT&amp;T", @filter.xml_escape("AT&T")
      assert_equal(
        "&lt;code&gt;command &amp;lt;filename&amp;gt;&lt;/code&gt;",
        @filter.xml_escape("<code>command &lt;filename&gt;</code>")
      )
    end

    should "not error when xml escaping nil" do
      assert_equal "", @filter.xml_escape(nil)
    end

    should "escape space as plus" do
      assert_equal "my+things", @filter.cgi_escape("my things")
    end

    should "escape special characters" do
      assert_equal "hey%21", @filter.cgi_escape("hey!")
    end

    should "escape space as %20" do
      assert_equal "my%20things", @filter.uri_escape("my things")
    end

    should "allow reserver characters in URI" do
      assert_equal(
        "foo!*'();:@&=+$,/?#[]bar",
        @filter.uri_escape("foo!*'();:@&=+$,/?#[]bar")
      )
      assert_equal(
        "foo%20bar!*'();:@&=+$,/?#[]baz",
        @filter.uri_escape("foo bar!*'();:@&=+$,/?#[]baz")
      )
    end

    context "absolute_url filter" do
      should "produce an absolute URL from a page URL" do
        page_url = "/about/my_favorite_page/"
        assert_equal "http://example.com/base#{page_url}", @filter.absolute_url(page_url)
      end

      should "ensure the leading slash" do
        page_url = "about/my_favorite_page/"
        assert_equal "http://example.com/base/#{page_url}", @filter.absolute_url(page_url)
      end

      should "ensure the leading slash for the baseurl" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "base",
        })
        assert_equal "http://example.com/base/#{page_url}", filter.absolute_url(page_url)
      end

      should "be ok with a blank but present 'url'" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({
          "url"     => "",
          "baseurl" => "base",
        })
        assert_equal "/base/#{page_url}", filter.absolute_url(page_url)
      end

      should "be ok with a nil 'url'" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({
          "url"     => nil,
          "baseurl" => "base",
        })
        assert_equal "/base/#{page_url}", filter.absolute_url(page_url)
      end

      should "be ok with a nil 'baseurl'" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => nil,
        })
        assert_equal "http://example.com/#{page_url}", filter.absolute_url(page_url)
      end

      should "not prepend a forward slash if input is empty" do
        page_url = ""
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/base",
        })
        assert_equal "http://example.com/base", filter.absolute_url(page_url)
      end

      should "not append a forward slash if input is '/'" do
        page_url = "/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/base",
        })
        assert_equal "http://example.com/base/", filter.absolute_url(page_url)
      end

      should "not append a forward slash if input is '/' and nil 'baseurl'" do
        page_url = "/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => nil,
        })
        assert_equal "http://example.com/", filter.absolute_url(page_url)
      end

      should "not append a forward slash if both input and baseurl are simply '/'" do
        page_url = "/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/",
        })
        assert_equal "http://example.com/", filter.absolute_url(page_url)
      end

      should "normalize international URLs" do
        page_url = ""
        filter = make_filter_mock({
          "url"     => "http://ümlaut.example.org/",
          "baseurl" => nil,
        })
        assert_equal "http://xn--mlaut-jva.example.org/", filter.absolute_url(page_url)
      end

      should "not modify an absolute URL" do
        page_url = "http://example.com/"
        assert_equal "http://example.com/", @filter.absolute_url(page_url)
      end

      should "transform the input URL to a string" do
        page_url = "/my-page.html"
        filter = make_filter_mock({ "url" => Value.new(proc { "http://example.org" }) })
        assert_equal "http://example.org#{page_url}", filter.absolute_url(page_url)
      end

      should "not raise a TypeError when passed a hash" do
        assert @filter.absolute_url({ "foo" => "bar" })
      end

      context "with a document" do
        setup do
          @site = fixture_site({
            "collections" => ["methods"],
          })
          @site.process
          @document = @site.collections["methods"].docs.detect do |d|
            d.relative_path == "_methods/configuration.md"
          end
        end

        should "make a url" do
          expected = "http://example.com/base/methods/configuration.html"
          assert_equal expected, @filter.absolute_url(@document)
        end
      end
    end

    context "relative_url filter" do
      should "produce a relative URL from a page URL" do
        page_url = "/about/my_favorite_page/"
        assert_equal "/base#{page_url}", @filter.relative_url(page_url)
      end

      should "ensure the leading slash between baseurl and input" do
        page_url = "about/my_favorite_page/"
        assert_equal "/base/#{page_url}", @filter.relative_url(page_url)
      end

      should "ensure the leading slash for the baseurl" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({ "baseurl" => "base" })
        assert_equal "/base/#{page_url}", filter.relative_url(page_url)
      end

      should "normalize international URLs" do
        page_url = "错误.html"
        assert_equal "/base/%E9%94%99%E8%AF%AF.html", @filter.relative_url(page_url)
      end

      should "be ok with a nil 'baseurl'" do
        page_url = "about/my_favorite_page/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => nil,
        })
        assert_equal "/#{page_url}", filter.relative_url(page_url)
      end

      should "not prepend a forward slash if input is empty" do
        page_url = ""
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/base",
        })
        assert_equal "/base", filter.relative_url(page_url)
      end

      should "not prepend a forward slash if baseurl ends with a single '/'" do
        page_url = "/css/main.css"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/base/",
        })
        assert_equal "/base/css/main.css", filter.relative_url(page_url)
      end

      should "not return valid URI if baseurl ends with multiple '/'" do
        page_url = "/css/main.css"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/base//",
        })
        refute_equal "/base/css/main.css", filter.relative_url(page_url)
      end

      should "not prepend a forward slash if both input and baseurl are simply '/'" do
        page_url = "/"
        filter = make_filter_mock({
          "url"     => "http://example.com",
          "baseurl" => "/",
        })
        assert_equal "/", filter.relative_url(page_url)
      end

      should "not return the url by reference" do
        filter = make_filter_mock({ :baseurl => nil })
        page = Page.new(filter.site, test_dir("fixtures"), "", "front_matter.erb")
        assert_equal "/front_matter.erb", page.url
        url = filter.relative_url(page.url)
        url << "foo"
        assert_equal "/front_matter.erb", page.url
      end

      should "transform the input baseurl to a string" do
        page_url = "/my-page.html"
        filter = make_filter_mock({ "baseurl" => Value.new(proc { "/baseurl/" }) })
        assert_equal "/baseurl#{page_url}", filter.relative_url(page_url)
      end

      should "transform protocol-relative url" do
        url = "//example.com/"
        assert_equal "/base//example.com/", @filter.relative_url(url)
      end

      should "not modify an absolute url with scheme" do
        url = "file:///file.html"
        assert_equal url, @filter.relative_url(url)
      end

      should "not normalize absolute international URLs" do
        url = "https://example.com/错误"
        assert_equal "https://example.com/错误", @filter.relative_url(url)
      end
    end

    context "strip_index filter" do
      should "strip trailing /index.html" do
        assert_equal "/foo/", @filter.strip_index("/foo/index.html")
      end

      should "strip trailing /index.htm" do
        assert_equal "/foo/", @filter.strip_index("/foo/index.htm")
      end

      should "not strip HTML in the middle of URLs" do
        assert_equal "/index.html/foo", @filter.strip_index("/index.html/foo")
      end

      should "not raise an error on nil strings" do
        assert_nil @filter.strip_index(nil)
      end

      should "not mangle other URLs" do
        assert_equal "/foo/", @filter.strip_index("/foo/")
      end
    end

    context "jsonify filter" do
      should "convert hash to json" do
        assert_equal "{\"age\":18}", @filter.jsonify({ :age => 18 })
      end

      should "convert array to json" do
        assert_equal "[1,2]", @filter.jsonify([1, 2])
        assert_equal(
          "[{\"name\":\"Jack\"},{\"name\":\"Smith\"}]",
          @filter.jsonify([{ :name => "Jack" }, { :name => "Smith" }])
        )
      end

      should "convert drop to json" do
        @filter.site.read
        expected = {
          "path"          => "_posts/2008-02-02-published.markdown",
          "previous"      => nil,
          "output"        => nil,
          "content"       => "This should be published.\n",
          "id"            => "/publish_test/2008/02/02/published",
          "url"           => "/publish_test/2008/02/02/published.html",
          "relative_path" => "_posts/2008-02-02-published.markdown",
          "collection"    => "posts",
          "excerpt"       => "<p>This should be published.</p>\n",
          "draft"         => false,
          "categories"    => [
            "publish_test",
          ],
          "layout"        => "default",
          "title"         => "Publish",
          "category"      => "publish_test",
          "date"          => "2008-02-02 00:00:00 +0000",
          "slug"          => "published",
          "ext"           => ".markdown",
          "tags"          => [],
        }
        actual = JSON.parse(@filter.jsonify(@filter.site.docs_to_write.first.to_liquid))

        next_doc = actual.delete("next")
        refute_nil next_doc
        assert next_doc.is_a?(Hash), "doc.next should be an object"

        assert_equal expected, actual
      end

      should "convert drop with drops to json" do
        @filter.site.read
        actual = @filter.jsonify(@filter.site.to_liquid)
        assert_equal JSON.parse(actual)["jekyll"], {
          "environment" => "development",
          "version"     => Jekyll::VERSION,
        }
      end

      # rubocop:disable Style/StructInheritance
      class M < Struct.new(:message)
        def to_liquid
          [message]
        end
      end
      class T < Struct.new(:name)
        def to_liquid
          {
            "name" => name,
            :v     => 1,
            :thing => M.new({ :kay => "jewelers" }),
            :stuff => true,
          }
        end
      end

      should "call #to_liquid " do
        expected = [
          {
            "name"  => "Jeremiah",
            "v"     => 1,
            "thing" => [
              {
                "kay" => "jewelers",
              },
            ],
            "stuff" => true,
          },
          {
            "name"  => "Smathers",
            "v"     => 1,
            "thing" => [
              {
                "kay" => "jewelers",
              },
            ],
            "stuff" => true,
          },
        ]
        result = @filter.jsonify([T.new("Jeremiah"), T.new("Smathers")])
        assert_equal expected, JSON.parse(result)
      end
      # rubocop:enable Style/StructInheritance

      should "handle hashes with all sorts of weird keys and values" do
        my_hash = { "posts" => Array.new(3) { |i| T.new(i) } }
        expected = {
          "posts" => [
            {
              "name"  => 0,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers",
                },
              ],
              "stuff" => true,
            },
            {
              "name"  => 1,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers",
                },
              ],
              "stuff" => true,
            },
            {
              "name"  => 2,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers",
                },
              ],
              "stuff" => true,
            },
          ],
        }
        result = @filter.jsonify(my_hash)
        assert_equal expected, JSON.parse(result)
      end
    end

    context "group_by filter" do
      should "successfully group array of Jekyll::Page's" do
        @filter.site.process
        grouping = @filter.group_by(@filter.site.pages, "layout")
        grouping.each do |g|
          assert(
            ["default", "nil", ""].include?(g["name"]),
            "#{g["name"]} isn't a valid grouping."
          )
          case g["name"]
          when "default"
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for 'default' is not an Array."
            )
            # adjust array.size to ignore symlinked page in Windows
            qty = Utils::Platforms.really_windows? ? 4 : 5
            assert_equal qty, g["items"].size
          when "nil"
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for 'nil' is not an Array."
            )
            assert_equal 2, g["items"].size
          when ""
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for '' is not an Array."
            )
            # adjust array.size to ignore symlinked page in Windows
            qty = Utils::Platforms.really_windows? ? 14 : 15
            assert_equal qty, g["items"].size
          end
        end
      end

      should "include the size of each grouping" do
        grouping = @filter.group_by(@filter.site.pages, "layout")
        grouping.each do |g|
          p g
          assert_equal(
            g["items"].size,
            g["size"],
            "The size property for '#{g["name"]}' doesn't match the size of the Array."
          )
        end
      end
    end

    context "where filter" do
      should "return any input that is not an array" do
        assert_equal "some string", @filter.where("some string", "la", "le")
      end

      should "filter objects in a hash appropriately" do
        hash = { "a" => { "color"=>"red" }, "b" => { "color"=>"blue" } }
        assert_equal 1, @filter.where(hash, "color", "red").length
        assert_equal [{ "color"=>"red" }], @filter.where(hash, "color", "red")
      end

      should "filter objects appropriately" do
        assert_equal 2, @filter.where(@array_of_objects, "color", "red").length
      end

      should "filter array properties appropriately" do
        hash = {
          "a" => { "tags"=>%w(x y) },
          "b" => { "tags"=>["x"] },
          "c" => { "tags"=>%w(y z) },
        }
        assert_equal 2, @filter.where(hash, "tags", "x").length
      end

      should "filter array properties alongside string properties" do
        hash = {
          "a" => { "tags"=>%w(x y) },
          "b" => { "tags"=>"x" },
          "c" => { "tags"=>%w(y z) },
        }
        assert_equal 2, @filter.where(hash, "tags", "x").length
      end

      should "not match substrings" do
        hash = {
          "a" => { "category"=>"bear" },
          "b" => { "category"=>"wolf" },
          "c" => { "category"=>%w(bear lion) },
        }
        assert_equal 0, @filter.where(hash, "category", "ear").length
      end

      should "stringify during comparison for compatibility with liquid parsing" do
        hash = {
          "The Words" => { "rating" => 1.2, "featured" => false },
          "Limitless" => { "rating" => 9.2, "featured" => true },
          "Hustle"    => { "rating" => 4.7, "featured" => true },
        }

        results = @filter.where(hash, "featured", "true")
        assert_equal 2, results.length
        assert_equal 9.2, results[0]["rating"]
        assert_equal 4.7, results[1]["rating"]

        results = @filter.where(hash, "rating", 4.7)
        assert_equal 1, results.length
        assert_equal 4.7, results[0]["rating"]
      end

      should "always return an array if the object responds to 'select'" do
        results = @filter.where(SelectDummy.new, "obj", "1 == 1")
        assert_equal [], results
      end
    end

    context "where_exp filter" do
      should "return any input that is not an array" do
        assert_equal "some string", @filter.where_exp("some string", "la", "le")
      end

      should "filter objects in a hash appropriately" do
        hash = { "a" => { "color"=>"red" }, "b" => { "color"=>"blue" } }
        assert_equal 1, @filter.where_exp(hash, "item", "item.color == 'red'").length
        assert_equal(
          [{ "color"=>"red" }],
          @filter.where_exp(hash, "item", "item.color == 'red'")
        )
      end

      should "filter objects appropriately" do
        assert_equal(
          2,
          @filter.where_exp(@array_of_objects, "item", "item.color == 'red'").length
        )
      end

      should "stringify during comparison for compatibility with liquid parsing" do
        hash = {
          "The Words" => { "rating" => 1.2, "featured" => false },
          "Limitless" => { "rating" => 9.2, "featured" => true },
          "Hustle"    => { "rating" => 4.7, "featured" => true },
        }

        results = @filter.where_exp(hash, "item", "item.featured == true")
        assert_equal 2, results.length
        assert_equal 9.2, results[0]["rating"]
        assert_equal 4.7, results[1]["rating"]

        results = @filter.where_exp(hash, "item", "item.rating == 4.7")
        assert_equal 1, results.length
        assert_equal 4.7, results[0]["rating"]
      end

      should "filter with other operators" do
        assert_equal [3, 4, 5], @filter.where_exp([ 1, 2, 3, 4, 5 ], "n", "n >= 3")
      end

      objects = [
        { "id" => "a", "groups" => [1, 2] },
        { "id" => "b", "groups" => [2, 3] },
        { "id" => "c" },
        { "id" => "d", "groups" => [1, 3] },
      ]
      should "filter with the contains operator over arrays" do
        results = @filter.where_exp(objects, "obj", "obj.groups contains 1")
        assert_equal 2, results.length
        assert_equal "a", results[0]["id"]
        assert_equal "d", results[1]["id"]
      end

      should "filter with the contains operator over hash keys" do
        results = @filter.where_exp(objects, "obj", "obj contains 'groups'")
        assert_equal 3, results.length
        assert_equal "a", results[0]["id"]
        assert_equal "b", results[1]["id"]
        assert_equal "d", results[2]["id"]
      end

      should "filter posts" do
        site = fixture_site.tap(&:read)
        posts = site.site_payload["site"]["posts"]
        results = @filter.where_exp(posts, "obj", "obj.title == 'Foo Bar'")
        assert_equal 1, results.length
        assert_equal site.posts.find { |p| p.title == "Foo Bar" }, results.first
      end

      should "always return an array if the object responds to 'select'" do
        results = @filter.where_exp(SelectDummy.new, "obj", "1 == 1")
        assert_equal [], results
      end

      should "filter by variable values" do
        @filter.site.tap(&:read)
        posts = @filter.site.site_payload["site"]["posts"]
        results = @filter.where_exp(posts, "post",
          "post.date > site.dont_show_posts_before")
        assert_equal posts.select { |p| p.date > @sample_time }.count, results.length
      end
    end

    context "group_by_exp filter" do
      should "successfully group array of Jekyll::Page's" do
        @filter.site.process
        groups = @filter.group_by_exp(@filter.site.pages, "page", "page.layout | upcase")
        groups.each do |g|
          assert(
            ["DEFAULT", "NIL", ""].include?(g["name"]),
            "#{g["name"]} isn't a valid grouping."
          )
          case g["name"]
          when "DEFAULT"
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for 'default' is not an Array."
            )
            # adjust array.size to ignore symlinked page in Windows
            qty = Utils::Platforms.really_windows? ? 4 : 5
            assert_equal qty, g["items"].size
          when "nil"
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for 'nil' is not an Array."
            )
            assert_equal 2, g["items"].size
          when ""
            assert(
              g["items"].is_a?(Array),
              "The list of grouped items for '' is not an Array."
            )
            # adjust array.size to ignore symlinked page in Windows
            qty = Utils::Platforms.really_windows? ? 14 : 15
            assert_equal qty, g["items"].size
          end
        end
      end

      should "include the size of each grouping" do
        groups = @filter.group_by_exp(@filter.site.pages, "page", "page.layout")
        groups.each do |g|
          assert_equal(
            g["items"].size,
            g["size"],
            "The size property for '#{g["name"]}' doesn't match the size of the Array."
          )
        end
      end

      should "allow more complex filters" do
        items = [
          { "version" => "1.0", "result" => "slow" },
          { "version" => "1.1.5", "result" => "medium" },
          { "version" => "2.7.3", "result" => "fast" },
        ]

        result = @filter.group_by_exp(items, "item", "item.version | split: '.' | first")
        assert_equal 2, result.size
      end

      should "be equivalent of group_by" do
        actual = @filter.group_by_exp(@filter.site.pages, "page", "page.layout")
        expected = @filter.group_by(@filter.site.pages, "layout")

        assert_equal expected, actual
      end

      should "return any input that is not an array" do
        assert_equal "some string", @filter.group_by_exp("some string", "la", "le")
      end

      should "group by full element (as opposed to a field of the element)" do
        items = %w(a b c d)

        result = @filter.group_by_exp(items, "item", "item")
        assert_equal 4, result.length
        assert_equal ["a"], result.first["items"]
      end

      should "accept hashes" do
        hash = { 1 => "a", 2 => "b", 3 => "c", 4 => "d" }

        result = @filter.group_by_exp(hash, "item", "item")
        assert_equal 4, result.length
      end
    end

    context "sort filter" do
      should "raise Exception when input is nil" do
        err = assert_raises ArgumentError do
          @filter.sort(nil)
        end
        assert_equal "Cannot sort a null object.", err.message
      end
      should "return sorted numbers" do
        assert_equal [1, 2, 2.2, 3], @filter.sort([3, 2.2, 2, 1])
      end
      should "return sorted strings" do
        assert_equal %w(10 2), @filter.sort(%w(10 2))
        assert_equal(
          [{ "a" => "10" }, { "a" => "2" }],
          @filter.sort([{ "a" => "10" }, { "a" => "2" }], "a")
        )
        assert_equal %w(FOO Foo foo), @filter.sort(%w(foo Foo FOO))
        assert_equal %w(_foo foo foo_), @filter.sort(%w(foo_ _foo foo))
        # Cyrillic
        assert_equal %w(ВУЗ Вуз вуз), @filter.sort(%w(Вуз вуз ВУЗ))
        assert_equal %w(_вуз вуз вуз_), @filter.sort(%w(вуз_ _вуз вуз))
        # Hebrew
        assert_equal %w(אלף בית), @filter.sort(%w(בית אלף))
      end
      should "return sorted by property array" do
        assert_equal [{ "a" => 1 }, { "a" => 2 }, { "a" => 3 }, { "a" => 4 }],
          @filter.sort([{ "a" => 4 }, { "a" => 3 }, { "a" => 1 }, { "a" => 2 }], "a")
      end
      should "return sorted by property array with nils first" do
        ary = [{ "a" => 2 }, { "b" => 1 }, { "a" => 1 }]
        assert_equal [{ "b" => 1 }, { "a" => 1 }, { "a" => 2 }], @filter.sort(ary, "a")
        assert_equal @filter.sort(ary, "a"), @filter.sort(ary, "a", "first")
      end
      should "return sorted by property array with nils last" do
        assert_equal [{ "a" => 1 }, { "a" => 2 }, { "b" => 1 }],
          @filter.sort([{ "a" => 2 }, { "b" => 1 }, { "a" => 1 }], "a", "last")
      end
      should "return sorted by subproperty array" do
        assert_equal [{ "a" => { "b" => 1 } }, { "a" => { "b" => 2 } },
                      { "a" => { "b" => 3 } }, ],
          @filter.sort([{ "a" => { "b" => 2 } }, { "a" => { "b" => 1 } },
                        { "a" => { "b" => 3 } }, ], "a.b")
      end
    end

    context "to_integer filter" do
      should "raise Exception when input is not integer or string" do
        assert_raises NoMethodError do
          @filter.to_integer([1, 2])
        end
      end
      should "return 0 when input is nil" do
        assert_equal 0, @filter.to_integer(nil)
      end
      should "return integer when input is boolean" do
        assert_equal 0, @filter.to_integer(false)
        assert_equal 1, @filter.to_integer(true)
      end
      should "return integers" do
        assert_equal 0, @filter.to_integer(0)
        assert_equal 1, @filter.to_integer(1)
        assert_equal 1, @filter.to_integer(1.42857)
        assert_equal(-1, @filter.to_integer(-1))
        assert_equal(-1, @filter.to_integer(-1.42857))
      end
    end

    context "inspect filter" do
      should "return a HTML-escaped string representation of an object" do
        assert_equal "{&quot;&lt;a&gt;&quot;=&gt;1}", @filter.inspect({ "<a>" => 1 })
      end

      should "quote strings" do
        assert_equal "&quot;string&quot;", @filter.inspect("string")
      end
    end

    context "slugify filter" do
      should "return a slugified string" do
        assert_equal "q-bert-says", @filter.slugify(" Q*bert says @!#?@!")
      end

      should "return a slugified string with mode" do
        assert_equal "q-bert-says-@!-@!", @filter.slugify(" Q*bert says @!#?@!", "pretty")
      end
    end

    context "push filter" do
      should "return a new array with the element pushed to the end" do
        assert_equal %w(hi there bernie), @filter.push(%w(hi there), "bernie")
      end
    end

    context "pop filter" do
      should "return a new array with the last element popped" do
        assert_equal %w(hi there), @filter.pop(%w(hi there bernie))
      end

      should "allow multiple els to be popped" do
        assert_equal %w(hi there bert), @filter.pop(%w(hi there bert and ernie), 2)
      end

      should "cast string inputs for # into nums" do
        assert_equal %w(hi there bert), @filter.pop(%w(hi there bert and ernie), "2")
      end
    end

    context "shift filter" do
      should "return a new array with the element removed from the front" do
        assert_equal %w(a friendly greeting), @filter.shift(%w(just a friendly greeting))
      end

      should "allow multiple els to be shifted" do
        assert_equal %w(bert and ernie), @filter.shift(%w(hi there bert and ernie), 2)
      end

      should "cast string inputs for # into nums" do
        assert_equal %w(bert and ernie), @filter.shift(%w(hi there bert and ernie), "2")
      end
    end

    context "unshift filter" do
      should "return a new array with the element put at the front" do
        assert_equal %w(aloha there bernie), @filter.unshift(%w(there bernie), "aloha")
      end
    end

    context "sample filter" do
      should "return a random item from the array" do
        input = %w(hey there bernie)
        assert_includes input, @filter.sample(input)
      end

      should "allow sampling of multiple values (n > 1)" do
        input = %w(hey there bernie)
        @filter.sample(input, 2).each do |val|
          assert_includes input, val
        end
      end
    end
  end
end
