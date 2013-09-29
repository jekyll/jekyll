require 'helper'

class TestPage < Test::Unit::TestCase
  def setup_page(*args)
    dir, file = args
    dir, file = ['', dir] if file.nil?
    @page = Page.new(@site, source_dir, dir, file)
  end

  def do_render(page)
    layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    page.render(layouts, {"site" => {"posts" => []}})
  end

  context "A Page" do
    setup do
      clear_dest
      stub(Jekyll).configuration { Jekyll::Configuration::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
    end

    context "processing pages" do
      should "create url based on filename" do
        @page = setup_page('contacts.html')
        assert_equal "/contacts.html", @page.url
      end

      context "in a directory hierarchy" do
        should "create url based on filename" do
          @page = setup_page('/contacts', 'bar.html')
          assert_equal "/contacts/bar.html", @page.url
        end

        should "create index url based on filename" do
          @page = setup_page('/contacts', 'index.html')
          assert_equal "/contacts/index.html", @page.url
        end
      end

      should "deal properly with extensions" do
        @page = setup_page('deal.with.dots.html')
        assert_equal ".html", @page.ext
      end

      should "deal properly with dots" do
        @page = setup_page('deal.with.dots.html')
        assert_equal "deal.with.dots", @page.basename
      end

      context "with no pages_permalink and pretty url style" do
        setup do
          @site.pages_permalink = nil
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

        context "in a directory hierarchy" do
          should "create url based on filename" do
            @page = setup_page('/contacts', 'bar.html')
            assert_equal "/contacts/bar/", @page.url
          end

          should "create index url based on filename" do
            @page = setup_page('/contacts', 'index.html')
            assert_equal "/contacts/", @page.url
          end

          should "return dir correctly" do
            @page = setup_page('/contacts', 'bar.html')
            assert_equal '/contacts/bar/', @page.dir
          end

          should "return dir correctly for index page" do
            @page = setup_page('/contacts', 'index.html')
            assert_equal '/contacts/', @page.dir
          end
        end
      end

      context "with pretty page permalink style" do
        setup do
          @site.pages_permalink = :pretty
        end

        should "return dir correctly" do
          @page = setup_page('contacts.html')
          assert_equal '/contacts/', @page.dir
        end

        should "return dir correctly for index page" do
          @page = setup_page('index.html')
          assert_equal '/', @page.dir
        end

        context "in a directory hierarchy" do
          should "create url based on filename" do
            @page = setup_page('/contacts', 'bar.html')
            assert_equal "/contacts/bar/", @page.url
          end

          should "create index url based on filename" do
            @page = setup_page('/contacts', 'index.html')
            assert_equal "/contacts/", @page.url
          end

          should "return dir correctly" do
            @page = setup_page('/contacts', 'bar.html')
            assert_equal '/contacts/bar/', @page.dir
          end

          should "return dir correctly for index page" do
            @page = setup_page('/contacts', 'index.html')
            assert_equal '/contacts/', @page.dir
          end
        end
      end

      context "with other user specified style" do
        setup do
          @site.pages_permalink = '/:path/:output_ext/:basename'
        end
        should "return dir correctly" do
          @page = setup_page('contacts.html')
          assert_equal '/.html/contacts', @page.url
        end
        should "return dir correctly for index page" do
          @page = setup_page('index.html')
          assert_equal '/.html', @page.dir
        end
      end

      context "with any other url style" do
        should "return dir correctly" do
          @site.pages_permalink = nil
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

      should "write even when the folder name is plus and permalink has +" do
        page = setup_page('+', 'foo.md')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir, '+', 'plus+in+url'))
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

      context "in a directory hierarchy" do
        should "write properly the index" do
          page = setup_page('/contacts', 'index.html')
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exists?(File.join(dest_dir, 'contacts', 'index.html'))
        end

        should "write properly" do
          page = setup_page('/contacts', 'bar.html')
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exists?(File.join(dest_dir, 'contacts', 'bar.html'))
        end

        should "write properly without html extension" do
          page = setup_page('/contacts', 'bar.html')
          page.site.permalink_style = :pretty
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exists?(File.join(dest_dir, 'contacts', 'bar', 'index.html'))
        end
      end
    end

  end
end
