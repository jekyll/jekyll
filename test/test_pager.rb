require 'helper'

class TestPager < Test::Unit::TestCase

  def build_site(config = {})
    base = Jekyll::Configuration::DEFAULTS.deep_merge({
      'source'      => source_dir,
      'destination' => dest_dir,
      'pagination'  => 1
    })
    site = Jekyll::Site.new(base.deep_merge(config))
    site.process
    site
  end

  should "calculate number of pages" do
    assert_equal(0, Pager.calculate_pages([], '2'))
    assert_equal(1, Pager.calculate_pages([1], '2'))
    assert_equal(1, Pager.calculate_pages([1,2], '2'))
    assert_equal(2, Pager.calculate_pages([1,2,3], '2'))
    assert_equal(2, Pager.calculate_pages([1,2,3,4], '2'))
    assert_equal(3, Pager.calculate_pages([1,2,3,4,5], '2'))
  end

  should "determine the pagination path" do
    #assert_equal("/index.html",  Pager.paginate_path(build_site, 1))
    assert_equal("/page2",       Pager.paginate_path(build_site, 2))
    #assert_equal("/index.html",  Pager.paginate_path(build_site('paginate_path' => '/blog/page-:num'), 1))
    assert_equal("/blog/page-2", Pager.paginate_path(build_site('paginate_path' => '/blog/page-:num'), 2))
    #assert_equal("/index.html",  Pager.paginate_path(build_site('paginate_path' => '/blog/page/:num'), 1))
    assert_equal("/blog/page/2", Pager.paginate_path(build_site('paginate_path' => '/blog/page/:num'), 2))
  end

  context "pagination disabled" do
    should "report that pagination is disabled" do
      assert !Pager.pagination_enabled?(build_site('paginate' => nil))
    end
  end

  context "pagination enabled for 2" do
    setup do
      @site  = build_site('paginate' => 2)
      @posts = @site.posts
    end

    should "report that pagination is enabled" do
      assert Pager.pagination_enabled?(@site)
    end

    context "with 4 posts" do
      setup do
        @posts = @site.posts[1..4] # limit to 4
      end

      should "create first pager" do
        pager = Pager.new(@site, 1, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(2, pager.total_pages)
        assert_nil(pager.previous_page)
        assert_equal(2, pager.next_page)
      end

      should "create second pager" do
        pager = Pager.new(@site, 2, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(2, pager.total_pages)
        assert_equal(1, pager.previous_page)
        assert_nil(pager.next_page)
      end

      should "not create third pager" do
        assert_raise(RuntimeError) { Pager.new(@site, 3, @posts) }
      end

    end

    context "with 5 posts" do
      setup do
        @posts = @site.posts[1..5] # limit to 5
      end

      should "create first pager" do
        pager = Pager.new(@site, 1, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_nil(pager.previous_page)
        assert_equal(2, pager.next_page)
      end

      should "create second pager" do
        pager = Pager.new(@site, 2, @posts)
        assert_equal(2, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_equal(1, pager.previous_page)
        assert_equal(3, pager.next_page)
      end

      should "create third pager" do
        pager = Pager.new(@site, 3, @posts)
        assert_equal(1, pager.posts.size)
        assert_equal(3, pager.total_pages)
        assert_equal(2, pager.previous_page)
        assert_nil(pager.next_page)
      end

      should "not create fourth pager" do
        assert_raise(RuntimeError) { Pager.new(@site, 4, @posts) }
      end

    end
  end
end
