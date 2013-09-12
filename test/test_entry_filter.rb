require 'helper'

class TestEntryFilter < Test::Unit::TestCase
  context "filtering site entries" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "filter entries" do
      ent1 = %w[foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~]
      ent2 = %w[.htaccess _posts _pages bla.bla]

      assert_equal %w[foo.markdown bar.markdown baz.markdown], EntryFilter.new(@site).filter(ent1)
      assert_equal %w[.htaccess bla.bla], EntryFilter.new(@site).filter(ent2)
    end

    should "filter entries with exclude" do
      excludes = %w[README TODO]
      files = %w[index.html site.css .htaccess]

      @site.exclude = excludes + ["exclude*"]
      assert_equal files, EntryFilter.new(@site).filter(excludes + files + ["excludeA"])
    end

    should "not filter entries within include" do
      includes = %w[_index.html .htaccess include*]
      files = %w[index.html _index.html .htaccess includeA]

      @site.include = includes
      assert_equal files, EntryFilter.new(@site).filter(files)
    end

    should "filter symlink entries when safe mode enabled" do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'safe' => true})
      end
      site = Site.new(Jekyll.configuration)
      stub(File).symlink?('symlink.js') {true}
      files = %w[symlink.js]
      assert_equal [], EntryFilter.new(site).filter(files)
    end

    should "not filter symlink entries when safe mode disabled" do
      stub(File).symlink?('symlink.js') {true}
      files = %w[symlink.js]
      assert_equal files, EntryFilter.new(@site).filter(files)
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
end
