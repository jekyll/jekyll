require 'helper'

class TestExcerpt < Test::Unit::TestCase
  def setup_post(file)
    Post.new(@site, source_dir, '', file)
  end

  def do_render(post)
    layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    post.render(layouts, {"site" => {"posts" => []}})
  end

  context "An extracted excerpt" do
    setup do
      clear_dest
      stub(Jekyll).configuration { Jekyll::Configuration::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
      @post = setup_post("2013-07-22-post-excerpt-with-layout.markdown")
    end

    context "#to_liquid" do
      should "contain the proper page data to mimick the post liquid" do
        assert_equal {}, @post.excerpt.to_liquid.to_s
      end
    end

    context "#content" do

      context "before render" do
        should "be the first paragraph of the page" do
          assert_equal "First paragraph with [link ref][link].\n\n[link]: http://www.jekyllrb.com/", @post.excerpt.to_s
        end

        should "contain any refs at the bottom of the page" do
          assert @post.excerpt.to_s.include?("[link]: http://www.jekyllrb.com/")
        end
      end

      context "after render" do
        setup do
          @rendered_post = @post.dup
          do_render(@rendered_post)
        end

        should "be the first paragraph of the page" do
          assert_equal "<p>First paragraph with <a href='http://www.jekyllrb.com/'>link ref</a>.</p>", @rendered_post.excerpt.content
        end

        should "link properly" do
          assert @rendered_post.excerpt.to_s.include?("http://www.jekyllrb.com/")
        end
      end
    end
  end
end
