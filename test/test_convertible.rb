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
      ret = @convertible.read_yaml(@base, 'front_matter.erb')
      assert_equal({'test' => 'good'}, ret)
    end

    should "not parse if the front-matter is not at the start of the file" do
      ret = @convertible.read_yaml(@base, 'broken_front_matter1.erb')
      assert_equal({}, ret)
    end
  end
end
