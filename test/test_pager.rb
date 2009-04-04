require File.dirname(__FILE__) + '/helper'

class TestPager < Test::Unit::TestCase
  
  def setup
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir,
        'paginate' => 2})
    end

    @config = Jekyll.configuration
    @site = Site.new(@config)
    @posts = @site.read_posts('')
  end
  
  def teardown
    @config = Jekyll.configuration('paginate' => nil)
  end
  
  def test_calculate_pages
    assert_equal(2, Pager.calculate_pages(@posts, @config['paginate']))
  end

  def test_create_first_pager
    pager = Pager.new(@config, 1, @posts)
    assert_equal(@config['paginate'].to_i, pager.posts.size)
    assert_equal(2, pager.total_pages)
    assert_nil(pager.previous_page)
    assert_equal(2, pager.next_page)
  end
  
  def test_create_second_pager
    pager = Pager.new(@config, 2, @posts)
    assert_equal(@posts.size - @config['paginate'].to_i, pager.posts.size)
    assert_equal(2, pager.total_pages)
    assert_equal(1, pager.previous_page)
    assert_nil(pager.next_page)
  end
  
  def test_create_third_pager
    assert_raise(RuntimeError) { Pager.new(@config, 3, @posts) }
  end
  
  def test_pagination_enabled_with_command_option
    assert_equal(true, Pager.pagination_enabled?(@config, 'index.html'))
  end
end