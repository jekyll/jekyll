require 'helper'
require 'ostruct'

class TestConvertible < Test::Unit::TestCase
  context "yaml front-matter" do
    setup do
      @convertible = OpenStruct.new
      @convertible.extend Jekyll::Convertible
      @base = File.expand_path('../fixtures', __FILE__)
    end

    should "parse the front-matter correctly" do
      path = File.join(@base, 'front_matter.erb')
      ret = @convertible.read_yaml(path)
      assert_equal({'test' => 'good'}, ret)
    end

    should "not parse if the front-matter is not at the start of the file" do
      path = File.join(@base, 'broken_front_matter1.erb')
      ret = @convertible.read_yaml(path)
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front-matter" do
      path = File.join(@base, 'broken_front_matter2.erb')
      out = capture_stdout do
        ret = @convertible.read_yaml(path)
        assert_equal({}, ret)
      end
      assert_match(/YAML Exception|syntax error|Error reading file/, out)
      assert_match(/#{path}/, out)
    end

    should "not allow ruby objects in yaml" do
      path = File.join(@base, 'exploit_front_matter.erb')
      out = capture_stdout do
        @convertible.read_yaml(path)
      end
      assert_no_match /undefined class\/module DoesNotExist/, out
    end

    should "not parse if there is encoding error in file" do
      path = File.join(@base, 'broken_front_matter3.erb')
      out = capture_stdout do
        ret = @convertible.read_yaml(path, :encoding => 'utf-8')
        assert_equal({}, ret)
      end
      assert_match(/invalid byte sequence in UTF-8/, out)
      assert_match(/#{File.join(@base, name)}/, out)
    end
  end
end
