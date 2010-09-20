require File.dirname(__FILE__) + '/helper'

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

      context "with pretty_flat url style" do
        setup do
          @site.permalink_style = :pretty_flat
        end

        should "return dir correctly" do
          @page = setup_page('contacts.html')
          assert_equal '/contacts', @page.url
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

      should "pretty_flat: write properly without html extension" do
        page = setup_page('contacts.html')
        page.site.permalink_style = :pretty_flat
        do_render(page)
        page.write(dest_dir)

        assert File.exists?(File.join(dest_dir, 'contacts'))
      end

      should "pretty_flat: write properly with extension different from html" do
        page = setup_page("sitemap.xml")
        page.site.permalink_style = :pretty_flat
        do_render(page)
        page.write(dest_dir)

        assert_equal("/sitemap.xml", page.url)
        assert_nil(page.url[/\.html$/])
        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir,'sitemap.xml'))
      end

    end

  end 
end
