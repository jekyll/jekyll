require 'helper'

class TestSiteMetaData < Test::Unit::TestCase
  context "storing modifcation time" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
      @num_invalid_posts = 2
    end

    should "store modification time by path" do
      @site.process
      post = @site.posts.first
      full_post_path = File.join(@site.source, post.path)
      metadata = SiteMetaData.new(@site)
      metadata.store(full_post_path)
      assert_equal metadata[full_post_path].fetch(:modification_time), File.mtime(full_post_path)
    end
  end

  context "disk persistence" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
      @num_invalid_posts = 2
    end

    teardown do
      FileUtils.rm_f(source_dir(".jekyll_metadata"))
    end

    should "create the metadata file in the site's source directory" do
      metadata = SiteMetaData.new(@site)
      metadata.write_to_disk
      assert_equal true, File.exists?(source_dir(".jekyll_metadata"))
    end

    context "reading from disk" do
      setup do
        @site.process
        metadata = SiteMetaData.new(@site)
        @site.posts.each do |post|
          full_post_path = File.join(@site.source, post.path)
          metadata.store(full_post_path)
        end
        metadata.write_to_disk
      end

      should "restore saved data from disk" do
        metadata = SiteMetaData.new(@site)
        metadata.read_from_disk
        full_post_path = File.join(@site.source, @site.posts.last.path)
        assert_equal metadata[full_post_path][:modification_time], File.mtime(full_post_path)
      end
    end
  end
end
