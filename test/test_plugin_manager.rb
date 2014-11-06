require 'helper'

class TestPluginManager < Test::Unit::TestCase
  def test_requiring_from_bundler
    Jekyll::PluginManager.require_from_bundler
    assert ENV["JEKYLL_NO_BUNDLER_REQUIRE"], 'Gemfile plugins were not required.'
  end
end
