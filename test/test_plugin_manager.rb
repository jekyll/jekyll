require 'helper'

class TestPluginManager < JekyllUnitTest
  def with_no_gemfile
    FileUtils.mv "Gemfile", "Gemfile.old"
    yield
  ensure
    FileUtils.mv "Gemfile.old", "Gemfile"
  end

  def test_requiring_from_bundler
    with_env("JEKYLL_NO_BUNDLER_REQUIRE", nil) do
      assert Jekyll::PluginManager.require_from_bundler, 'require_from_bundler should return true.'
      assert ENV["JEKYLL_NO_BUNDLER_REQUIRE"], 'Gemfile plugins were not required.'
    end
  end

  def test_blocking_requiring_from_bundler
    with_env("JEKYLL_NO_BUNDLER_REQUIRE", "true") do
      assert_equal false, Jekyll::PluginManager.require_from_bundler, "Gemfile plugins were required but shouldn't have been"
      assert ENV["JEKYLL_NO_BUNDLER_REQUIRE"]
    end
  end

  def test_no_gemfile
    with_env("JEKYLL_NO_BUNDLER_REQUIRE", nil) do
      with_no_gemfile do
        assert_equal false, Jekyll::PluginManager.require_from_bundler, "Gemfile plugins were required but shouldn't have been"
        assert_nil ENV["JEKYLL_NO_BUNDLER_REQUIRE"]
      end
    end
  end
end
