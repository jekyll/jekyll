# frozen_string_literal: true

require "helper"

class TestUtils < JekyllUnitTest
  context "The \`Utils.deep_merge_hashes\` method" do
    setup do
      clear_dest
      @site = fixture_site
      @site.process
    end

    should "merge a drop into a hash" do
      data = { "page" => {} }
      merged = Utils.deep_merge_hashes(data, @site.site_payload)
      assert merged.is_a? Hash
      assert merged["site"].is_a? Drops::SiteDrop
      assert_equal data["page"], merged["page"]
    end

    should "merge a hash into a drop" do
      data = { "page" => {} }
      assert_nil @site.site_payload["page"]
      merged = Utils.deep_merge_hashes(@site.site_payload, data)
      assert merged.is_a? Drops::UnifiedPayloadDrop
      assert merged["site"].is_a? Drops::SiteDrop
      assert_equal data["page"], merged["page"]
    end
  end

  context "hash" do
    context "pluralized_array" do
      should "return empty array with no values" do
        data = {}
        assert_equal [], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return empty array with no matching values" do
        data = { "foo" => "bar" }
        assert_equal [], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return plural array with nil singular" do
        data = { "foo" => "bar", "tag" => nil, "tags" => %w(dog cat) }
        assert_equal %w(dog cat), Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return single value array with matching singular" do
        data = { "foo" => "bar", "tag" => "dog", "tags" => %w(dog cat) }
        assert_equal ["dog"], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return single value array with matching singular with spaces" do
        data = { "foo" => "bar", "tag" => "dog cat", "tags" => %w(dog cat) }
        assert_equal ["dog cat"], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return empty array with matching nil plural" do
        data = { "foo" => "bar", "tags" => nil }
        assert_equal [], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return empty array with matching empty array" do
        data = { "foo" => "bar", "tags" => [] }
        assert_equal [], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return single value array with matching plural with single string value" do
        data = { "foo" => "bar", "tags" => "dog" }
        assert_equal ["dog"], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return multiple value array with matching plural with " \
             "single string value with spaces" do
        data = { "foo" => "bar", "tags" => "dog cat" }
        assert_equal %w(dog cat), Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return single value array with matching plural with single value array" do
        data = { "foo" => "bar", "tags" => ["dog"] }
        assert_equal ["dog"], Utils.pluralized_array_from_hash(data, "tag", "tags")
      end

      should "return multiple value array with matching plural with " \
             "multiple value array" do
        data = { "foo" => "bar", "tags" => %w(dog cat) }
        assert_equal %w(dog cat), Utils.pluralized_array_from_hash(data, "tag", "tags")
      end
    end
  end

  context "The \`Utils.parse_date\` method" do
    should "parse a properly formatted date" do
      assert Utils.parse_date("2014-08-02 14:43:06 PDT").is_a? Time
    end

    should "throw an error if the input contains no date data" do
      assert_raises Jekyll::Errors::InvalidDateError do
        Utils.parse_date("Blah")
      end
    end

    should "throw an error if the input is out of range" do
      assert_raises Jekyll::Errors::InvalidDateError do
        Utils.parse_date("9999-99-99")
      end
    end

    should "throw an error with the default message if no message is passed in" do
      date = "Blah this is invalid"
      assert_raises(
        Jekyll::Errors::InvalidDateError,
        "Invalid date '#{date}': Input could not be parsed."
      ) do
        Utils.parse_date(date)
      end
    end

    should "throw an error with the provided message if a message is passed in" do
      date = "Blah this is invalid"
      message = "Aaaah, the world has exploded!"
      assert_raises(
        Jekyll::Errors::InvalidDateError,
        "Invalid date '#{date}': #{message}"
      ) do
        Utils.parse_date(date, message)
      end
    end
  end

  context "The \`Utils.slugify\` method" do
    should "return nil if passed nil" do
      begin
        assert Utils.slugify(nil).nil?
      rescue NoMethodError
        assert false, "Threw NoMethodError"
      end
    end

    should "replace whitespace with hyphens" do
      assert_equal "working-with-drafts", Utils.slugify("Working with drafts")
    end

    should "replace consecutive whitespace with a single hyphen" do
      assert_equal "basic-usage", Utils.slugify("Basic   Usage")
    end

    should "trim leading and trailing whitespace" do
      assert_equal "working-with-drafts", Utils.slugify("  Working with drafts   ")
    end

    should "drop trailing punctuation" do
      assert_equal(
        "so-what-is-jekyll-exactly",
        Utils.slugify("So what is Jekyll, exactly?")
      )
      assert_equal "كيف-حالك", Utils.slugify("كيف حالك؟")
    end

    should "ignore hyphens" do
      assert_equal "pre-releases", Utils.slugify("Pre-releases")
    end

    should "replace underscores with hyphens" do
      assert_equal "the-config-yml-file", Utils.slugify("The _config.yml file")
    end

    should "combine adjacent hyphens and spaces" do
      assert_equal(
        "customizing-git-git-hooks",
        Utils.slugify("Customizing Git - Git Hooks")
      )
    end

    should "replace punctuation in any scripts by hyphens" do
      assert_equal "5時-6時-三-一四", Utils.slugify("5時〜6時 三・一四")
    end

    should "not modify the original string" do
      title = "Quick-start guide"
      Utils.slugify(title)
      assert_equal "Quick-start guide", title
    end

    should "not change behaviour if mode is default" do
      assert_equal(
        "the-config-yml-file",
        Utils.slugify("The _config.yml file?", :mode => "default")
      )
    end

    should "not change behaviour if mode is nil" do
      assert_equal "the-config-yml-file", Utils.slugify("The _config.yml file?")
    end

    should "not replace period and underscore if mode is pretty" do
      assert_equal(
        "the-_config.yml-file",
        Utils.slugify("The _config.yml file?", :mode => "pretty")
      )
    end

    should "replace everything else but ASCII characters" do
      assert_equal "the-config-yml-file",
                   Utils.slugify("The _config.yml file?", :mode => "ascii")
      assert_equal "f-rtive-glance",
                   Utils.slugify("fürtive glance!!!!", :mode => "ascii")
    end

    should "map accented latin characters to ASCII characters" do
      assert_equal "the-config-yml-file",
                   Utils.slugify("The _config.yml file?", :mode => "latin")
      assert_equal "furtive-glance",
                   Utils.slugify("fürtive glance!!!!", :mode => "latin")
      assert_equal "aaceeiioouu",
                   Utils.slugify("àáçèéíïòóúü", :mode => "latin")
      assert_equal "a-z",
                   Utils.slugify("Aあわれ鬱господинZ", :mode => "latin")
    end

    should "only replace whitespace if mode is raw" do
      assert_equal(
        "the-_config.yml-file?",
        Utils.slugify("The _config.yml file?", :mode => "raw")
      )
    end

    should "return the given string if mode is none" do
      assert_equal(
        "the _config.yml file?",
        Utils.slugify("The _config.yml file?", :mode => "none")
      )
    end

    should "Keep all uppercase letters if cased is true" do
      assert_equal(
        "Working-with-drafts",
        Utils.slugify("Working with drafts", :cased => true)
      )
      assert_equal(
        "Basic-Usage",
        Utils.slugify("Basic   Usage", :cased => true)
      )
      assert_equal(
        "Working-with-drafts",
        Utils.slugify("  Working with drafts   ", :cased => true)
      )
      assert_equal(
        "So-what-is-Jekyll-exactly",
        Utils.slugify("So what is Jekyll, exactly?", :cased => true)
      )
      assert_equal(
        "Pre-releases",
        Utils.slugify("Pre-releases", :cased => true)
      )
      assert_equal(
        "The-config-yml-file",
        Utils.slugify("The _config.yml file", :cased => true)
      )
      assert_equal(
        "Customizing-Git-Git-Hooks",
        Utils.slugify("Customizing Git - Git Hooks", :cased => true)
      )
      assert_equal(
        "The-config-yml-file",
        Utils.slugify("The _config.yml file?", :mode => "default", :cased => true)
      )
      assert_equal(
        "The-config-yml-file",
        Utils.slugify("The _config.yml file?", :cased => true)
      )
      assert_equal(
        "The-_config.yml-file",
        Utils.slugify("The _config.yml file?", :mode => "pretty", :cased => true)
      )
      assert_equal(
        "The-_config.yml-file?",
        Utils.slugify("The _config.yml file?", :mode => "raw", :cased => true)
      )
      assert_equal(
        "The _config.yml file?",
        Utils.slugify("The _config.yml file?", :mode => "none", :cased => true)
      )
    end

    should "records a warning in the log if the returned slug is empty" do
      expect(Jekyll.logger).to receive(:warn)
      assert_equal "", Utils.slugify("💎")
    end
  end

  context "The \`Utils.titleize_slug\` method" do
    should "capitalize all words and not drop any words" do
      assert_equal(
        "This Is A Long Title With Mixed Capitalization",
        Utils.titleize_slug("This-is-a-Long-title-with-Mixed-capitalization")
      )
      assert_equal(
        "This Is A Title With Just The Initial Word Capitalized",
        Utils.titleize_slug("This-is-a-title-with-just-the-initial-word-capitalized")
      )
      assert_equal(
        "This Is A Title With No Capitalization",
        Utils.titleize_slug("this-is-a-title-with-no-capitalization")
      )
    end
  end

  context "The \`Utils.add_permalink_suffix\` method" do
    should "handle built-in permalink styles" do
      assert_equal(
        "/:basename/",
        Utils.add_permalink_suffix("/:basename", :pretty)
      )
      assert_equal(
        "/:basename:output_ext",
        Utils.add_permalink_suffix("/:basename", :date)
      )
      assert_equal(
        "/:basename:output_ext",
        Utils.add_permalink_suffix("/:basename", :ordinal)
      )
      assert_equal(
        "/:basename:output_ext",
        Utils.add_permalink_suffix("/:basename", :none)
      )
    end

    should "handle custom permalink styles" do
      assert_equal(
        "/:basename/",
        Utils.add_permalink_suffix("/:basename", "/:title/")
      )
      assert_equal(
        "/:basename:output_ext",
        Utils.add_permalink_suffix("/:basename", "/:title:output_ext")
      )
      assert_equal(
        "/:basename",
        Utils.add_permalink_suffix("/:basename", "/:title")
      )
    end
  end

  context "The \`Utils.safe_glob\` method" do
    should "not apply pattern to the dir" do
      dir = "test/safe_glob_test["
      assert_equal [], Dir.glob(dir + "/*") unless jruby?
      assert_equal ["test/safe_glob_test[/find_me.txt"], Utils.safe_glob(dir, "*")
    end

    should "return the same data to #glob" do
      dir = "test"
      assert_equal Dir.glob(dir + "/*"), Utils.safe_glob(dir, "*")
      assert_equal Dir.glob(dir + "/**/*"), Utils.safe_glob(dir, "**/*")
    end

    should "return the same data to #glob if dir is not found" do
      dir = "dir_not_exist"
      assert_equal [], Utils.safe_glob(dir, "*")
      assert_equal Dir.glob(dir + "/*"), Utils.safe_glob(dir, "*")
    end

    should "return the same data to #glob if pattern is blank" do
      dir = "test"
      assert_equal [dir], Utils.safe_glob(dir, "")
      assert_equal Dir.glob(dir), Utils.safe_glob(dir, "")
      assert_equal Dir.glob(dir), Utils.safe_glob(dir, nil)
    end

    should "return the same data to #glob if flag is given" do
      dir = "test"
      assert_equal Dir.glob(dir + "/*", File::FNM_DOTMATCH),
                   Utils.safe_glob(dir, "*", File::FNM_DOTMATCH)
    end

    should "support pattern as an array to support windows" do
      dir = "test"
      assert_equal Dir.glob(dir + "/**/*"), Utils.safe_glob(dir, ["**", "*"])
    end
  end

  context "The \`Utils.has_yaml_header?\` method" do
    should "accept files with YAML front matter" do
      file = source_dir("_posts", "2008-10-18-foo-bar.markdown")
      assert_equal "---\n", File.open(file, "rb") { |f| f.read(4) }
      assert Utils.has_yaml_header?(file)
    end
    should "accept files with extraneous spaces after YAML front matter" do
      file = source_dir("_posts", "2015-12-27-extra-spaces.markdown")
      assert_equal "---  \n", File.open(file, "rb") { |f| f.read(6) }
      assert Utils.has_yaml_header?(file)
    end
    should "reject pgp files and the like which resemble front matter" do
      file = source_dir("pgp.key")
      assert_equal "-----B", File.open(file, "rb") { |f| f.read(6) }
      refute Utils.has_yaml_header?(file)
    end
  end

  context "The \`Utils.merged_file_read_opts\` method" do
    should "ignore encoding if it's not there" do
      opts = Utils.merged_file_read_opts(nil, {})
      assert_nil opts["encoding"]
      assert_nil opts[:encoding]
    end

    should "add bom to encoding" do
      opts = { "encoding" => "utf-8", :encoding => "utf-8" }
      merged = Utils.merged_file_read_opts(nil, opts)
      assert_equal "bom|utf-8", merged["encoding"]
      assert_equal "bom|utf-8", merged[:encoding]
    end

    should "preserve bom in encoding" do
      opts = { "encoding" => "bom|another", :encoding => "bom|another" }
      merged = Utils.merged_file_read_opts(nil, opts)
      assert_equal "bom|another", merged["encoding"]
      assert_equal "bom|another", merged[:encoding]
    end
  end

  context "Utils::Internet.connected?" do
    should "return true if there's internet" do
      assert Utils::Internet.connected?
    end
  end
end
