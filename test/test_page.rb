require 'helper'

class TestPage < Test::Unit::TestCase
  def setup_page(file)
    @page = Page.new(@site, source_dir, '', file)
  end

  def do_render(page)
    layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    page.render(layouts, {"site" => {"posts" => []}})
  end

  context "A Page" do
    setup do
      clear_dest
      stub(Jekyll).configuration { Jekyll::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
    end

    context "processing pages" do
      should "create url based on filename" do
        @page = setup_page('contacts.html')
        assert_equal "/contacts.html", @page.url
      end

      should "deal properly with extensions" do
        @page = setup_page('deal.with.dots.html')
        assert_equal ".html", @page.ext
      end

      should "deal properly with dots" do
        @page = setup_page('deal.with.dots.html')
        assert_equal "deal.with.dots", @page.basename
      end

      context "with pretty url style" do
        setup do
          @site.permalink_style = :pretty
        end

        should "return dir correctly" do
          @page = setup_page('contacts.html')
          assert_equal '/contacts/', @page.dir
        end

        should "return dir correctly for index page" do
          @page = setup_page('index.html')
          assert_equal '/', @page.dir
        end
      end

      context "with any other url style" do
        should "return dir correctly" do
          @site.permalink_style = nil
          @page = setup_page('contacts.html')
          assert_equal '/', @page.dir
        end
      end

      should "respect permalink in yaml front matter" do
        file = "about.html"
        @page = setup_page(file)

        assert_equal "/about/", @page.permalink
        assert_equal @page.permalink, @page.url
        assert_equal "/about/", @page.dir
      end
    end
    
    context "with unspecified layout" do
      setup do
        @page = setup_page('contacts.html')
      end

      should "default to 'post' layout" do
        assert_equal "page", @page.data["layout"]
      end
    end
        
    context "with specified layout of nil" do
      setup do
        @page = setup_page('sitemap.xml')
      end

      should "layout of nil is respected" do
        assert_equal "nil", @page.data["layout"]
      end
    end

    context "rendering" do
      setup do
        clear_dest
      end

      should "write properly" do
        page = setup_page('contacts.html')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir, 'contacts.html'))
      end

      should "write properly without html extension" do
        page = setup_page('contacts.html')
        page.site.permalink_style = :pretty
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir, 'contacts', 'index.html'))
      end

      should "write properly with extension different from html" do
        page = setup_page("sitemap.xml")
        page.site.permalink_style = :pretty
        do_render(page)
        page.write(dest_dir)

        assert_equal("/sitemap.xml", page.url)
        assert_nil(page.url[/\.html$/])
        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir,'sitemap.xml'))
      end

      should "write dotfiles properly" do
        page = setup_page('.htaccess')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir, '.htaccess'))
      end
    end

  end
end
