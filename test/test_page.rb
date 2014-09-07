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
      @site = Site.new(Jekyll.configuration({
        "source" => source_dir,
        "destination" => dest_dir,
        "skip_config_files" => true
      }))
    end

    context "processing pages" do
      should "create url based on filename" do
        @page = setup_page('contacts.html')
        assert_equal "/contacts.html", @page.url
      end

      should "not published when published yaml is false" do
        @page = setup_page("unpublished.html")
        assert_equal false, @page.published?
      end

      should "create url with non-alphabetic characters" do
        @page = setup_page('+', '%# +.md')
        assert_equal "/+/%25%23%20+.html", @page.url
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

      should "make properties accessible through #[]" do
        page = setup_page('properties.html')
        attrs = {
          content: "All the properties.\n",
          dir: "/properties/",
          excerpt: nil,
          foo: 'bar',
          layout: 'default',
          name: "properties.html",
          path: "properties.html",
          permalink: '/properties/',
          published: nil,
          title: 'Properties Page',
          url: "/properties/"
        }

        attrs.each do |attr, val|
          attr_str = attr.to_s
          result = page[attr_str]
          assert_equal val, result, "For <page[\"#{attr_str}\"]>:"
        end
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

      should "not be writable outside of destination" do
        unexpected = File.expand_path("../../../baddie.html", dest_dir)
        File.delete unexpected if File.exist?(unexpected)
        page = setup_page("exploit.md")
        do_render(page)
        page.write(dest_dir)

        assert !File.exist?(unexpected)
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
        assert File.exist?(File.join(dest_dir, 'contacts.html'))
      end

      should "write even when the folder name is plus and permalink has +" do
        page = setup_page('+', 'foo.md')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exist?(File.join(dest_dir, '+', 'plus+in+url'))
      end

      should "write even when permalink has '%# +'" do
        page = setup_page('+', '%# +.md')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exist?(File.join(dest_dir, '+', '%# +.html'))
      end

      should "write properly without html extension" do
        page = setup_page('contacts.html')
        page.site.permalink_style = :pretty
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exist?(File.join(dest_dir, 'contacts', 'index.html'))
      end

      should "write properly with extension different from html" do
        page = setup_page("sitemap.xml")
        page.site.permalink_style = :pretty
        do_render(page)
        page.write(dest_dir)

        assert_equal("/sitemap.xml", page.url)
        assert_nil(page.url[/\.html$/])
        assert File.directory?(dest_dir)
        assert File.exist?(File.join(dest_dir,'sitemap.xml'))
      end

      should "write dotfiles properly" do
        page = setup_page('.htaccess')
        do_render(page)
        page.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exist?(File.join(dest_dir, '.htaccess'))
      end

      context "in a directory hierarchy" do
        should "write properly the index" do
          page = setup_page('/contacts', 'index.html')
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, 'contacts', 'index.html'))
        end

        should "write properly" do
          page = setup_page('/contacts', 'bar.html')
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, 'contacts', 'bar.html'))
        end

        should "write properly without html extension" do
          page = setup_page('/contacts', 'bar.html')
          page.site.permalink_style = :pretty
          do_render(page)
          page.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, 'contacts', 'bar', 'index.html'))
        end
      end
    end

  end
end
