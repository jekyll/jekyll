require 'helper'

class TestPluginManager < Test::Unit::TestCase
  def test_requiring_from_bundler
    with_env("JEKYLL_NO_BUNDLER_REQUIRE", nil) do
      Jekyll::PluginManager.require_from_bundler
      assert ENV["JEKYLL_NO_BUNDLER_REQUIRE"], 'Gemfile plugins were not required.'
    end
  end

  def test_blocking_requiring_from_bundler
    with_env("JEKYLL_NO_BUNDLER_REQUIRE", "true") do
      assert_equal false, Jekyll::PluginManager.require_from_bundler, "Gemfile plugins were required but shouldn't have been"
    end
  end
end
