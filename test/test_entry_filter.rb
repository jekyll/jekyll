# frozen_string_literal: true

require "helper"

class TestEntryFilter < JekyllUnitTest
  context "Filtering entries" do
    setup do
      @site = Site.new(site_configuration)
    end

    should "filter entries" do
      ent1 = %w(foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~ .htaccess _posts _pages ~$benbalter.docx)

      entries = EntryFilter.new(@site).filter(ent1)
      assert_equal %w(foo.markdown bar.markdown baz.markdown .htaccess), entries
    end

    should "allow regexp filtering" do
      files = %w(README.md)
      @site.exclude = [
        %r!README!,
      ]

      assert_empty @site.reader.filter_entries(
        files
      )
    end

    should "filter entries with exclude" do
      excludes = %w(README TODO vendor/bundle)
      files = %w(index.html site.css .htaccess vendor)

      @site.exclude = excludes + ["exclude*"]
      assert_equal files, @site.reader.filter_entries(excludes + files + ["excludeA"])
    end

    should "filter entries with exclude relative to site source" do
      excludes = %w(README TODO css)
      files = %w(index.html vendor/css .htaccess)

      @site.exclude = excludes
      assert_equal files, @site.reader.filter_entries(excludes + files + ["css"])
    end

    should "filter excluded directory and contained files" do
      excludes = %w(README TODO css)
      files = %w(index.html .htaccess)

      @site.exclude = excludes
      assert_equal(
        files,
        @site.reader.filter_entries(
          excludes + files + ["css", "css/main.css", "css/vendor.css"]
        )
      )
    end

    should "not filter entries within include" do
      includes = %w(_index.html .htaccess include*)
      files = %w(index.html _index.html .htaccess includeA)

      @site.include = includes
      assert_equal files, @site.reader.filter_entries(files)
    end

    should "keep safe symlink entries when safe mode enabled" do
      allow(File).to receive(:symlink?).with("symlink.js").and_return(true)
      files = %w(symlink.js)
      assert_equal files, @site.reader.filter_entries(files)
    end

    should "not filter symlink entries when safe mode disabled" do
      allow(File).to receive(:symlink?).with("symlink.js").and_return(true)
      files = %w(symlink.js)
      assert_equal files, @site.reader.filter_entries(files)
    end

    should "filter symlink pointing outside site source" do
      ent1 = %w(_includes/tmp)
      entries = EntryFilter.new(@site).filter(ent1)
      assert_equal %w(), entries
    end

    # rubocop:disable Performance/FixedSize
    should "include only safe symlinks in safe mode" do
      # no support for symlinks on Windows
      skip_if_windows "Jekyll does not currently support symlinks on Windows."

      site = Site.new(site_configuration("safe" => true))
      site.reader.read_directories("symlink-test")

      assert_equal %w(main.scss symlinked-file).length, site.pages.length
      refute_equal [], site.static_files
    end
    # rubocop:enable Performance/FixedSize

    should "include symlinks in unsafe mode" do
      # no support for symlinks on Windows
      skip_if_windows "Jekyll does not currently support symlinks on Windows."

      site = Site.new(site_configuration)

      site.reader.read_directories("symlink-test")
      refute_equal [], site.pages
      refute_equal [], site.static_files
    end
  end

  context "#glob_include?" do
    setup do
      @site = Site.new(site_configuration)
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
      data = ["vendor/bundle"]
      assert @filter.glob_include?(data, "/vendor/bundle")
      assert @filter.glob_include?(data, "vendor/bundle")
    end
  end
end
