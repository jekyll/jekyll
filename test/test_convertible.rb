require 'helper'
require 'ostruct'

class TestConvertible < JekyllUnitTest
  context "yaml front-matter" do
    setup do
      @convertible = OpenStruct.new(
        "site" => Site.new(Jekyll.configuration(
          "source" => File.expand_path('../fixtures', __FILE__)
        ))
      )
      @convertible.extend Jekyll::Convertible
      @base = File.expand_path('../fixtures', __FILE__)
    end

    should "parse the front-matter correctly" do
      ret = @convertible.read_yaml(@base, 'front_matter.erb')
      assert_equal({'test' => 'good'}, ret)
    end

    should "not parse if the front-matter is not at the start of the file" do
      ret = @convertible.read_yaml(@base, 'broken_front_matter1.erb')
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front-matter" do
      name = 'broken_front_matter2.erb'
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name)
        assert_equal({}, ret)
      end
      assert_match(/YAML Exception|syntax error|Error reading file/, out)
      assert_match(/#{File.join(@base, name)}/, out)
    end

    should "not allow ruby objects in yaml" do
      out = capture_stderr do
        @convertible.read_yaml(@base, 'exploit_front_matter.erb')
      end
      refute_match /undefined class\/module DoesNotExist/, out
    end

    should "not parse if there is encoding error in file" do
      name = 'broken_front_matter3.erb'
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name, :encoding => 'utf-8')
        assert_equal({}, ret)
      end
      assert_match(/invalid byte sequence in UTF-8/, out)
      assert_match(/#{File.join(@base, name)}/, out)
    end
  end
end
