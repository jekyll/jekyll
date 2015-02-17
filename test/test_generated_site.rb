require 'helper'

class TestGeneratedSite < Test::Unit::TestCase
  context "generated sites" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir('index.html'))
    end

    should "ensure post count is as expected" do
      assert_equal 47, @site.posts.size
    end

    should "insert site.posts into the index" do
      assert @index.include?("#{@site.posts.size} Posts")
    end

    should "render latest post's content" do
      assert @index.include?(@site.posts.last.content)
    end

    should "hide unpublished posts" do
      published = Dir[dest_dir('publish_test/2008/02/02/*.html')].map {|f| File.basename(f)}

      assert_equal 1, published.size
      assert_equal "published.html", published.first
    end

    should "hide unpublished page" do
      assert !File.exist?(dest_dir('/unpublished.html'))
    end

    should "not copy _posts directory" do
      assert !File.exist?(dest_dir('_posts'))
    end

    should "process other static files and generate correct permalinks" do
      assert File.exist?(dest_dir('/about/index.html'))
      assert File.exist?(dest_dir('/contacts.html'))
    end

    should "print a nice list of static files" do
      expected_output = Regexp.new <<-OUTPUT
- /css/screen.css last edited at \\d+ with extname .css
- /pgp.key last edited at \\d+ with extname .key
- /products.yml last edited at \\d+ with extname .yml
- /symlink-test/symlinked-dir/screen.css last edited at \\d+ with extname .css
OUTPUT
      assert_match expected_output, File.read(dest_dir('static_files.html'))
    end
  end

  context "generating limited posts" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'limit_posts' => 5})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir('index.html'))
    end

    should "generate only the specified number of posts" do
      assert_equal 5, @site.posts.size
    end

    should "ensure limit posts is 0 or more" do
      assert_raise ArgumentError do
        clear_dest
        stub(Jekyll).configuration do
          Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'limit_posts' => -1})
        end

        @site = Site.new(Jekyll.configuration)
      end
    end

    should "acceptable limit post is 0" do
      assert_nothing_raised ArgumentError do
        clear_dest
        stub(Jekyll).configuration do
          Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'limit_posts' => 0})
        end

        @site = Site.new(Jekyll.configuration)
      end
    end
  end
end
