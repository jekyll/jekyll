require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  context "creating sites" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "have an empty tag hash by default" do
      assert_equal Hash.new, @site.tags
    end

    should "reset data before processing" do
      clear_dest
      @site.process
      before_posts = @site.posts.length
      before_layouts = @site.layouts.length
      before_categories = @site.categories.length

      @site.process
      assert_equal before_posts, @site.posts.length
      assert_equal before_layouts, @site.layouts.length
      assert_equal before_categories, @site.categories.length
    end

    should "read layouts" do
      @site.read_layouts
      assert_equal ["default", "simple"].sort, @site.layouts.keys.sort
    end

    should "read posts" do
      @site.read_posts('')
      posts = Dir[source_dir('_posts', '*')]
      assert_equal posts.size - 1, @site.posts.size
    end

    should "deploy payload" do
      clear_dest
      @site.process

      posts = Dir[source_dir("**", "_posts", "*")]
      categories = %w(bar baz category foo z_category publish_test win).sort

      assert_equal posts.size - 1, @site.posts.size
      assert_equal categories, @site.categories.keys.sort
      assert_equal 4, @site.categories['foo'].size
    end

    should "filter entries" do
      ent1 = %w[foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~]
      ent2 = %w[.htaccess _posts bla.bla]

      assert_equal %w[foo.markdown bar.markdown baz.markdown], @site.filter_entries(ent1)
      assert_equal ent2, @site.filter_entries(ent2)
    end

    should "filter entries with exclude" do
      excludes = %w[README TODO]
      includes = %w[index.html site.css]

      @site.exclude = excludes
      assert_equal includes, @site.filter_entries(excludes + includes)
    end
    
    context 'with an invalid markdown processor in the configuration' do
      
      should 'give a meaningful error message' do
        bad_processor = 'not a processor name'
        begin
          Site.new(Jekyll.configuration.merge({ 'markdown' => bad_processor }))
          flunk 'Invalid markdown processors should cause a failure on site creation'
        rescue RuntimeError => e
          assert e.to_s =~ /invalid|bad/i
          assert e.to_s =~ %r{#{bad_processor}}
        end
      end
      
    end
    
  end
end
