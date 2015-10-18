require 'helper'

class TestExcerpt < JekyllUnitTest
  def setup_post(file)
    Document.new(@site.in_source_dir(File.join('_posts', file)), {
      site:       @site,
      collection: @site.posts
    }).tap(&:read)
  end

  def do_render(document)
    @site.layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    payload = {"site" => {"posts" => []}}
    document.output = Jekyll::Renderer.new(@site, document, payload).run
  end

  context "With extraction disabled" do
    setup do
      clear_dest
      @site = fixture_site('excerpt_separator' => '')
      @post = setup_post("2013-07-22-post-excerpt-with-layout.markdown")
    end

    should "not be generated" do
      refute @post.generate_excerpt?
    end
  end

  context "An extracted excerpt" do
    setup do
      clear_dest
      @site = fixture_site
      @post = setup_post("2013-07-22-post-excerpt-with-layout.markdown")
      @excerpt = @post.data['excerpt']
    end

    context "#include(string)" do

      setup do
        @excerpt.output = "Here is a fake output stub"
      end

      should "return true only if an excerpt output contains a specified string" do
        assert @excerpt.include?("fake output")
        refute @excerpt.include?("real output")
      end
    end

    context "#id" do
      should "contain the UID for the post" do
        assert_equal @excerpt.id, "#{@post.id}#excerpt"
      end
      should "return a string" do
        assert_same @post.id.class, String
      end
    end

    context "#to_s" do
      should "return rendered output" do
        assert_equal @excerpt.output, @excerpt.to_s
      end

      should "return its output if output present" do
        @excerpt.output = "Fake Output"
        assert_equal @excerpt.output, @excerpt.to_s
      end
    end

    context "#inspect" do
      should "contain the excerpt id as a shorthand string identifier" do
        assert_equal @excerpt.inspect, "<Excerpt: #{@excerpt.id}>"
      end

      should "return a string" do
        assert_same @post.id.class, String
      end
    end

    context "#to_liquid" do
      should "contain the proper page data to mimick the post liquid" do
        assert_equal "Post Excerpt with Layout", @excerpt.to_liquid["title"]
        assert_equal "/bar/baz/z_category/mixedcase/2013/07/22/post-excerpt-with-layout.html", @excerpt.to_liquid["url"]
        assert_equal Time.parse("2013-07-22"), @excerpt.to_liquid["date"]
        assert_equal %w[bar baz z_category MixedCase], @excerpt.to_liquid["categories"]
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
          @extracted_excerpt = @rendered_post.data['excerpt']
        end

        should "be the first paragraph of the page" do
          assert_equal "<p>First paragraph with <a href=\"http://www.jekyllrb.com/\">link ref</a>.</p>\n\n", @extracted_excerpt.output
        end

        should "link properly" do
          assert @extracted_excerpt.content.include?("http://www.jekyllrb.com/")
        end
      end
    end
  end

  context "A whole-post excerpt" do
    setup do
      clear_dest
      @site = fixture_site
      @post = setup_post("2008-02-02-published.markdown")
      @excerpt = @post.data['excerpt']
    end

    should "be generated" do
      assert_equal true, @excerpt.is_a?(Jekyll::Excerpt)
    end

    context "#content" do
      should "match the post content" do
        assert_equal @post.content, @excerpt.content
      end
    end
  end
end
