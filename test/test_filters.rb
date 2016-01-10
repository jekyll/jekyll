# coding: utf-8

require 'helper'

class TestFilters < JekyllUnitTest
  class JekyllFilter
    include Jekyll::Filters
    attr_accessor :site, :context

    def initialize(opts = {})
      @site = Jekyll::Site.new(Jekyll.configuration(opts.merge('skip_config_files' => true)))
      @context = Liquid::Context.new({}, {}, { :site => @site })
    end
  end

  context "filters" do
    setup do
      @filter = JekyllFilter.new({"source" => source_dir, "destination" => dest_dir, "timezone" => "UTC"})
      @sample_time = Time.utc(2013, 03, 27, 11, 22, 33)
      @sample_date = Date.parse("2013-03-27")
      @time_as_string = "September 11, 2001 12:46:30 -0000"
      @time_as_numeric = 1399680607
      @array_of_objects = [
        { "color" => "red",  "size" => "large"  },
        { "color" => "red",  "size" => "medium" },
        { "color" => "blue", "size" => "medium" }
      ]
    end

    should "markdownify with simple string" do
      assert_equal "<p>something <strong>really</strong> simple</p>\n", @filter.markdownify("something **really** simple")
    end

    context "smartify filter" do
      should "convert quotes and typographic characters" do
        assert_equal "SmartyPants is *not* Markdown", @filter.smartify("SmartyPants is *not* Markdown")
        assert_equal "“This filter’s test…”", @filter.smartify(%q{"This filter's test..."})
      end

      should "escapes special characters when configured to do so" do
        kramdown = JekyllFilter.new({:kramdown => {:entity_output => :symbolic}})
        assert_equal "&ldquo;This filter&rsquo;s test&hellip;&rdquo;", kramdown.smartify(%q{"This filter's test..."})
      end

      should "convert HTML entities to unicode characters" do
        assert_equal "’", @filter.smartify("&rsquo;")
        assert_equal "“", @filter.smartify("&ldquo;")
      end

      should "allow raw HTML passthrough" do
        assert_equal "Span HTML is <em>not</em> escaped", @filter.smartify("Span HTML is <em>not</em> escaped")
        assert_equal "<div>Block HTML is not escaped</div>", @filter.smartify("<div>Block HTML is not escaped</div>")
      end

      should "escape special characters" do
        assert_equal "3 &lt; 4", @filter.smartify("3 < 4")
        assert_equal "5 &gt; 4", @filter.smartify("5 > 4")
        assert_equal "This &amp; that", @filter.smartify("This & that")
      end
    end

    should "sassify with simple string" do
      assert_equal "p {\n  color: #123456; }\n", @filter.sassify("$blue:#123456\np\n  color: $blue")
    end

    should "scssify with simple string" do
      assert_equal "p {\n  color: #123456; }\n", @filter.scssify("$blue:#123456; p{color: $blue}")
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
      assert_equal "chunky and bacon", @filter.array_to_sentence_string(["chunky", "bacon"])
    end

    should "convert array to sentence string with multiple args" do
      assert_equal "1, 2, 3, and 4", @filter.array_to_sentence_string([1, 2, 3, 4])
      assert_equal "chunky, bacon, bits, and pieces", @filter.array_to_sentence_string(["chunky", "bacon", "bits", "pieces"])
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
          assert_equal "2013-03-27T11:22:33+00:00", @filter.date_to_xmlschema(@sample_time)
        end

        should "format a time according to RFC-822" do
          assert_equal "Wed, 27 Mar 2013 11:22:33 +0000", @filter.date_to_rfc822(@sample_time)
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
          assert_equal "2013-03-27T00:00:00+00:00", @filter.date_to_xmlschema(@sample_date)
        end

        should "format a time according to RFC-822" do
          assert_equal "Wed, 27 Mar 2013 00:00:00 +0000", @filter.date_to_rfc822(@sample_date)
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
          assert_equal "2001-09-11T12:46:30+00:00", @filter.date_to_xmlschema(@time_as_string)
        end

        should "format a time according to RFC-822" do
          assert_equal "Tue, 11 Sep 2001 12:46:30 +0000", @filter.date_to_rfc822(@time_as_string)
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
          assert_match /2014-05-10T00:10:07/, @filter.date_to_xmlschema(@time_as_numeric)
        end

        should "format a time according to RFC-822" do
          assert_equal "Sat, 10 May 2014 00:10:07 +0000", @filter.date_to_rfc822(@time_as_numeric)
        end
      end
    end

    should "escape xml with ampersands" do
      assert_equal "AT&amp;T", @filter.xml_escape("AT&T")
      assert_equal "&lt;code&gt;command &amp;lt;filename&amp;gt;&lt;/code&gt;", @filter.xml_escape("<code>command &lt;filename&gt;</code>")
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

    context "jsonify filter" do
      should "convert hash to json" do
        assert_equal "{\"age\":18}", @filter.jsonify({:age => 18})
      end

      should "convert array to json" do
        assert_equal "[1,2]", @filter.jsonify([1, 2])
        assert_equal "[{\"name\":\"Jack\"},{\"name\":\"Smith\"}]", @filter.jsonify([{:name => 'Jack'}, {:name => 'Smith'}])
      end

      class M < Struct.new(:message)
        def to_liquid
          [message]
        end
      end
      class T < Struct.new(:name)
        def to_liquid
          { "name" => name, :v => 1, :thing => M.new({:kay => "jewelers"}), :stuff => true }
        end
      end

      should "call #to_liquid " do
        expected = [
          {
            "name"  => "Jeremiah",
            "v"     => 1,
            "thing" => [
              {
                "kay" => "jewelers"
              }
            ],
            "stuff" => true
          },
          {
            "name"  => "Smathers",
            "v"     => 1,
            "thing" => [
              {
                "kay" => "jewelers"
              }
            ],
            "stuff" => true
          }
        ]
        result = @filter.jsonify([T.new("Jeremiah"), T.new("Smathers")])
        assert_equal expected, JSON.parse(result)
      end

      should "handle hashes with all sorts of weird keys and values" do
        my_hash = { "posts" => Array.new(3) { |i| T.new(i) } }
        expected = {
          "posts" => [
            {
              "name"  => 0,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers"
                }
              ],
              "stuff" => true
            },
            {
              "name"  => 1,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers"
                }
              ],
              "stuff" => true
            },
            {
              "name"  => 2,
              "v"     => 1,
              "thing" => [
                {
                  "kay" => "jewelers"
                }
              ],
              "stuff" => true
            }
          ]
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
          assert ["default", "nil", ""].include?(g["name"]), "#{g['name']} isn't a valid grouping."
          case g["name"]
          when "default"
            assert g["items"].is_a?(Array), "The list of grouped items for 'default' is not an Array."
            assert_equal 5, g["items"].size
          when "nil"
            assert g["items"].is_a?(Array), "The list of grouped items for 'nil' is not an Array."
            assert_equal 2, g["items"].size
          when ""
            assert g["items"].is_a?(Array), "The list of grouped items for '' is not an Array."
            assert_equal 12, g["items"].size
          end
        end
      end
    end

    context "where filter" do
      should "return any input that is not an array" do
        assert_equal "some string", @filter.where("some string", "la", "le")
      end

      should "filter objects in a hash appropriately" do
        hash = {"a"=>{"color"=>"red"}, "b"=>{"color"=>"blue"}}
        assert_equal 1, @filter.where(hash, "color", "red").length
        assert_equal [{"color"=>"red"}], @filter.where(hash, "color", "red")
      end

      should "filter objects appropriately" do
        assert_equal 2, @filter.where(@array_of_objects, "color", "red").length
      end

      should "stringify during comparison for compatibility with liquid parsing" do
        hash = {
          "The Words" => {"rating" => 1.2, "featured" => false},
          "Limitless" => {"rating" => 9.2, "featured" => true},
          "Hustle"    => {"rating" => 4.7, "featured" => true},
        }

        results = @filter.where(hash, "featured", "true")
        assert_equal 2, results.length
        assert_equal 9.2, results[0]["rating"]
        assert_equal 4.7, results[1]["rating"]

        results = @filter.where(hash, "rating", 4.7)
        assert_equal 1, results.length
        assert_equal 4.7, results[0]["rating"]
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
        assert_equal ["10", "2"], @filter.sort(["10", "2"])
        assert_equal [{"a" => "10"}, {"a" => "2"}], @filter.sort([{"a" => "10"}, {"a" => "2"}], "a")
        assert_equal ["FOO", "Foo", "foo"], @filter.sort(["foo", "Foo", "FOO"])
        assert_equal ["_foo", "foo", "foo_"], @filter.sort(["foo_", "_foo", "foo"])
        # Cyrillic
        assert_equal ["ВУЗ", "Вуз", "вуз"], @filter.sort(["Вуз", "вуз", "ВУЗ"])
        assert_equal ["_вуз", "вуз", "вуз_"], @filter.sort(["вуз_", "_вуз", "вуз"])
        # Hebrew
        assert_equal ["אלף", "בית"], @filter.sort(["בית", "אלף"])
      end
      should "return sorted by property array" do
        assert_equal [{"a" => 1}, {"a" => 2}, {"a" => 3}, {"a" => 4}],
          @filter.sort([{"a" => 4}, {"a" => 3}, {"a" => 1}, {"a" => 2}], "a")
      end
      should "return sorted by property array with nils first" do
        ary = [{"a" => 2}, {"b" => 1}, {"a" => 1}]
        assert_equal [{"b" => 1}, {"a" => 1}, {"a" => 2}], @filter.sort(ary, "a")
        assert_equal @filter.sort(ary, "a"), @filter.sort(ary, "a", "first")
      end
      should "return sorted by property array with nils last" do
        assert_equal [{"a" => 1}, {"a" => 2}, {"b" => 1}],
          @filter.sort([{"a" => 2}, {"b" => 1}, {"a" => 1}], "a", "last")
      end
    end

    context "inspect filter" do
      should "return a HTML-escaped string representation of an object" do
        assert_equal "{&quot;&lt;a&gt;&quot;=&gt;1}", @filter.inspect({ "<a>" => 1 })
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
        assert_equal %w{hi there bernie}, @filter.push(%w{hi there}, "bernie")
      end
    end

    context "pop filter" do
      should "return a new array with the last element popped" do
        assert_equal %w{hi there}, @filter.pop(%w{hi there bernie})
      end

      should "allow multiple els to be popped" do
        assert_equal %w{hi there bert}, @filter.pop(%w{hi there bert and ernie}, 2)
      end

      should "cast string inputs for # into nums" do
        assert_equal %w{hi there bert}, @filter.pop(%w{hi there bert and ernie}, "2")
      end
    end

    context "shift filter" do
      should "return a new array with the element removed from the front" do
        assert_equal %w{a friendly greeting}, @filter.shift(%w{just a friendly greeting})
      end

      should "allow multiple els to be shifted" do
        assert_equal %w{bert and ernie}, @filter.shift(%w{hi there bert and ernie}, 2)
      end

      should "cast string inputs for # into nums" do
        assert_equal %w{bert and ernie}, @filter.shift(%w{hi there bert and ernie}, "2")
      end
    end

    context "unshift filter" do
      should "return a new array with the element put at the front" do
        assert_equal %w{aloha there bernie}, @filter.unshift(%w{there bernie}, "aloha")
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
