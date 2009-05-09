require File.dirname(__FILE__) + '/helper'

class TestPager < Test::Unit::TestCase
  context "pagination enabled" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({
          'source'      => source_dir, 
          'destination' => dest_dir,
          'paginate'    => 2
        })
      end

      @config = Jekyll.configuration
      @site = Site.new(@config)
      @posts = @site.read_posts('')
    end

    should "calculate number of pages" do
      assert_equal(2, Pager.calculate_pages(@posts, @config['paginate']))
    end

    should "create first pager" do
      pager = Pager.new(@config, 1, @posts)
      assert_equal(@config['paginate'].to_i, pager.posts.size)
      assert_equal(2, pager.total_pages)
      assert_nil(pager.previous_page)
      assert_equal(2, pager.next_page)
    end
  
    should "create second pager" do
      pager = Pager.new(@config, 2, @posts)
      assert_equal(@posts.size - @config['paginate'].to_i, pager.posts.size)
      assert_equal(2, pager.total_pages)
      assert_equal(1, pager.previous_page)
      assert_nil(pager.next_page)
    end
    
    should "not create third pager" do
      assert_raise(RuntimeError) { Pager.new(@config, 3, @posts) }
    end
    
    should "report that pagination is enabled" do
      assert Pager.pagination_enabled?(@config, 'index.html')
    end
  end
end
