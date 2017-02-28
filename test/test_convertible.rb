require "helper"
require "ostruct"

class TestConvertible < JekyllUnitTest
  context "YAML front matter" do
    setup do
      @convertible = OpenStruct.new(
        "site" => Site.new(Jekyll.configuration(
          "source" => File.expand_path("../fixtures", __FILE__)
        ))
      )
      @convertible.extend Jekyll::Convertible
      @base = File.expand_path("../fixtures", __FILE__)
    end

    should "parse the front matter correctly" do
      ret = @convertible.read_yaml(@base, "front_matter.erb")
      assert_equal({ "test" => "good" }, ret)
    end

    should "not parse if the front matter is not at the start of the file" do
      ret = @convertible.read_yaml(@base, "broken_front_matter1.erb")
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front matter" do
      name = "broken_front_matter2.erb"
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name)
        assert_equal({}, ret)
      end
      assert_match(%r!YAML Exception|syntax error|Error reading file!, out)
      assert_match(%r!#{File.join(@base, name)}!, out)
    end

    should "not allow ruby objects in YAML" do
      out = capture_stderr do
        @convertible.read_yaml(@base, "exploit_front_matter.erb")
      end
      refute_match(%r!undefined class\/module DoesNotExist!, out)
    end

    should "not parse if there is encoding error in file" do
      name = "broken_front_matter3.erb"
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name, :encoding => "utf-8")
        assert_equal({}, ret)
      end
      assert_match(%r!invalid byte sequence in UTF-8!, out)
      assert_match(%r!#{File.join(@base, name)}!, out)
    end

    should "parse the front matter but show an error if permalink is empty" do
      name = "empty_permalink.erb"
      assert_raises(Errors::InvalidPermalinkError) do
        @convertible.read_yaml(@base, name)
      end
    end

    should "parse the front matter correctly without permalink" do
      out = capture_stderr do
        @convertible.read_yaml(@base, "front_matter.erb")
      end
      refute_match(%r!Invalid permalink!, out)
    end

    should "parse detached front matter correctly" do
      ret = @convertible.read_yaml(@base, "detached_front_matter1.md")
      assert_equal({ "test" => "I was defined in detached yaml file" }, ret)
    end

    should "merge detached front matter with inline front matter" do
      # here we want to test proper merging of detached and inline front matters
      #   yaml data from detached_front_matter2.md.fm.yml will be merged with
      #   inline yaml front matter from detached_front_matter2.md
      expected = {
        "test1" => {
          "a" => {
            "aa" => "inline_overriden_a_aa",
            "xx" => "inline_added_a_xx"
          },
          "b" => {
            "bb" => "detached_b_bb"
          },
          "c" => {
            "cc" => "inline_added_c_cc"
          }
        },
        "test2" => "detached",
        "test3" => "inline"
      }
      ret = @convertible.read_yaml(@base, "detached_front_matter2.md")
      assert_equal(expected, ret)
    end

    should "not parse if there is syntax error in detached front matter" do
      name = "detached_front_matter3_broken.md"
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name)
        assert_equal({}, ret)
      end
      assert_match(%r!YAML Exception|syntax error|Error reading file!, out)
      assert_match(%r!#{File.join(@base, name+".fm.yaml")}!, out)
    end

    should "not allow ruby objects in detached front matter" do
      out = capture_stderr do
        @convertible.read_yaml(@base, "detached_front_matter4_exploit.md")
      end
      refute_match(%r!undefined class\/module DoesNotExist!, out)
    end

    should "allow nil detached front matter" do
      ret = @convertible.read_yaml(@base, "detached_front_matter5_nil.md")
      assert_equal({}, ret)
    end

    should "allow empty detached front matter" do
      ret = @convertible.read_yaml(@base, "detached_front_matter6_false.md")
      assert_equal({}, ret)
    end

    should "not parse if there is non-hash detached front matter" do
      name = "detached_front_matter7_nonhash.md"
      exception = assert_raises Errors::InvalidYAMLFrontMatterError do
        @convertible.read_yaml(@base, name)
      end
      assert_match(%r!Invalid YAML front matter.*expected a hash.*instead got 'true'!,
        exception.message)
      assert_match(%r!#{File.join(@base, name+".fm.yaml")}!, exception.message)
    end
  end
end
