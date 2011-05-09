require 'helper'

class TestPager < Test::Unit::TestCase

  should "calculate number of pages" do
    assert_equal(0, Pager.calculate_pages([], '2'))
    assert_equal(1, Pager.calculate_pages([1], '2'))
    assert_equal(1, Pager.calculate_pages([1,2], '2'))
    assert_equal(2, Pager.calculate_pages([1,2,3], '2'))
    assert_equal(2, Pager.calculate_pages([1,2,3,4], '2'))
    assert_equal(3, Pager.calculate_pages([1,2,3,4,5], '2'))
  end

  context "pagination disabled" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({
          'source'      => source_dir,
          'destination' => dest_dir
        })
      end
      @config = Jekyll.configuration
    end

    should "report that pagination is disabled" do
      assert !Pager.pagination_enabled?(@config, 'index.html')
    end

  end

  context "pagination enabled for 2" do
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
      @site.process
      @posts = @site.posts
    end

    should "report that pagination is enabled" do
      assert Pager.pagination_enabled?(@config, 'index.html')
    end

    context "with 4 posts" do
      setup do
        @posts = @site.posts[1..4] # limit to 4
      end

      should "create first pager" do
        pager = Pager.new(@config, 1, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(2, pager.total_pages)
        assert_nil(pager.previous_page)
        assert_equal(2, pager.next_page)
      end

      should "create second pager" do
        pager = Pager.new(@config, 2, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(2, pager.total_pages)
        assert_equal(1, pager.previous_page)
        assert_nil(pager.next_page)
      end

      should "not create third pager" do
        assert_raise(RuntimeError) { Pager.new(@config, 3, @posts) }
      end

    end

    context "with 5 posts" do
      setup do
        @posts = @site.posts[1..5] # limit to 5
      end

      should "create first pager" do
        pager = Pager.new(@config, 1, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_nil(pager.previous_page)
        assert_equal(2, pager.next_page)
      end

      should "create second pager" do
        pager = Pager.new(@config, 2, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_equal(1, pager.previous_page)
        assert_equal(3, pager.next_page)
      end

      should "create third pager" do
        pager = Pager.new(@config, 3, @posts)
        assert_equal(1, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_equal(2, pager.previous_page)
        assert_nil(pager.next_page)
      end

      should "not create fourth pager" do
        assert_raise(RuntimeError) { Pager.new(@config, 4, @posts) }
      end

    end
  end
end
