require 'helper'

class TestExcerpt < Test::Unit::TestCase
  def setup_post(file)
    Post.new(@site, source_dir, '', file)
  end

  def do_render(post)
    layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    post.render(layouts, {"site" => {"posts" => []}})
  end

  context "With extraction disabled" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'excerpt_separator' => ''})
      end
      @site = Site.new(Jekyll.configuration)
      @post = setup_post("2013-07-22-post-excerpt-with-layout.markdown")
    end

    should "not be generated" do
      excerpt = @post.send(:extract_excerpt)
      assert_equal true, excerpt.empty?
    end
  end

  context "An extracted excerpt" do
    setup do
      clear_dest
      stub(Jekyll).configuration { Jekyll::Configuration::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
      @post = setup_post("2013-07-22-post-excerpt-with-layout.markdown")
      @excerpt = @post.send :extract_excerpt
    end

    context "#to_liquid" do
      should "contain the proper page data to mimick the post liquid" do
        assert_equal "Post Excerpt with Layout", @excerpt.to_liquid["title"]
        assert_equal "/bar/baz/z_category/2013/07/22/post-excerpt-with-layout.html", @excerpt.to_liquid["url"]
        assert_equal Time.parse("2013-07-22"), @excerpt.to_liquid["date"]
        assert_equal %w[bar baz z_category], @excerpt.to_liquid["categories"]
        assert_equal %w[first second third jekyllrb.com], @excerpt.to_liquid["tags"]
        assert_equal "_posts/2013-07-22-post-excerpt-with-layout.markdown", @excerpt.to_liquid["path"]
      end
    end

    context "#content" do

      context "before render" do
        should "be the first paragraph of the page" do
          assert_equal "First paragraph with [link ref][link].\n\n[link]: http://www.jekyllrb.com/", @excerpt.content
        end

        should "contain any refs at the bottom of the page" do
          assert @excerpt.content.include?("[link]: http://www.jekyllrb.com/")
        end
      end

      context "after render" do
        setup do
          @rendered_post = @post.dup
          do_render(@rendered_post)
          @extracted_excerpt = @rendered_post.send :extracted_excerpt
        end

        should "be the first paragraph of the page" do
          assert_equal "<p>First paragraph with <a href=\"http://www.jekyllrb.com/\">link ref</a>.</p>", @extracted_excerpt.content
        end

        should "link properly" do
          assert @extracted_excerpt.content.include?("http://www.jekyllrb.com/")
        end
      end
    end
  end
end
