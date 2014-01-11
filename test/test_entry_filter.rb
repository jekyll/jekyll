require 'helper'

class TestEntryFilter < Test::Unit::TestCase
  context "Filtering entries" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "filter entries" do
      ent1 = %w[foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~ .htaccess _posts _pages]

      entries = EntryFilter.new(@site).filter(ent1)
      assert_equal %w[foo.markdown bar.markdown baz.markdown .htaccess], entries
    end

    should "filter entries with exclude" do
      excludes = %w[README TODO vendor/bundle]
      files = %w[index.html site.css .htaccess vendor]

      @site.exclude = excludes + ["exclude*"]
      assert_equal files, @site.filter_entries(excludes + files + ["excludeA"])
    end

    should "not filter entries within include" do
      includes = %w[_index.html .htaccess include*]
      files = %w[index.html _index.html .htaccess includeA]

      @site.include = includes
      assert_equal files, @site.filter_entries(files)
    end

    should "filter symlink entries when safe mode enabled" do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'safe' => true})
      end
      site = Site.new(Jekyll.configuration)
      stub(File).symlink?('symlink.js') {true}
      files = %w[symlink.js]
      assert_equal [], site.filter_entries(files)
    end

    should "not filter symlink entries when safe mode disabled" do
      stub(File).symlink?('symlink.js') {true}
      files = %w[symlink.js]
      assert_equal files, @site.filter_entries(files)
    end

    should "not include symlinks in safe mode" do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'safe' => true})
      end
      site = Site.new(Jekyll.configuration)

      site.read_directories("symlink-test")
      assert_equal [], site.pages
      assert_equal [], site.static_files
    end

    should "include symlinks in unsafe mode" do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'safe' => false})
      end
      site = Site.new(Jekyll.configuration)

      site.read_directories("symlink-test")
      assert_not_equal [], site.pages
      assert_not_equal [], site.static_files
    end
  end

  context "glob_include?" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
      @filter = EntryFilter.new(@site)
    end

    should "return false with no glob patterns" do
      assert !@filter.glob_include?([], "a.txt")
    end

    should "return false with all not match path" do
      data = ["a*", "b?"]
      assert !@filter.glob_include?(data, "ca.txt")
      assert !@filter.glob_include?(data, "ba.txt")
    end

    should "return true with match path" do
      data = ["a*", "b?", "**/a*"]
      assert @filter.glob_include?(data, "a.txt")
      assert @filter.glob_include?(data, "ba")
      assert @filter.glob_include?(data, "c/a/a.txt")
      assert @filter.glob_include?(data, "c/a/b/a.txt")
    end

    should "match even if there is no leading slash" do
      data = ['vendor/bundle']
      assert @filter.glob_include?(data, '/vendor/bundle')
      assert @filter.glob_include?(data, 'vendor/bundle')
    end
  end
end
