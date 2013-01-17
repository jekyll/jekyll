require 'helper'

class TestGeneratedSite < Test::Unit::TestCase
  context "generated sites" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir('index.html'))
    end

    should "ensure post count is as expected" do
      assert_equal 30, @site.posts.size
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

    should "not copy _posts directory" do
      assert !File.exist?(dest_dir('_posts'))
    end

    should "process other static files and generate correct permalinks" do
      assert File.exists?(dest_dir('/about/index.html'))
      assert File.exists?(dest_dir('/contacts.html'))
    end
  end

  context "generating limited posts" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'limit_posts' => 5})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir('index.html'))
    end

    should "generate only the specified number of posts" do
      assert_equal 5, @site.posts.size
    end

    should "ensure limit posts is 1 or more" do
      assert_raise ArgumentError do
        clear_dest
        stub(Jekyll).configuration do
          Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir, 'limit_posts' => 0})
        end

        @site = Site.new(Jekyll.configuration)
      end
    end
  end
end
