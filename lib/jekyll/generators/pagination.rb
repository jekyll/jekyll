module Jekyll
  module Generators
    class Pagination < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # Generate paginated pages if necessary.
      #
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)
        if Pager.pagination_enabled?(site)
          if template = template_page(site)
            paginate(site, template)
          else
            Jekyll.logger.warn "Pagination:", "Pagination is enabled, but I couldn't find" +
            "an index.html page to use as the pagination template. Skipping pagination."
          end
        end
      end

      # Paginates the blog's posts. Renders the index.html file into paginated
      # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
      # site-wide data.
      #
      # site - The Site.
      # page - The index.html Page that requires pagination.
      #
      # {"paginator" => { "page" => <Number>,
      #                   "per_page" => <Number>,
      #                   "posts" => [<Post>],
      #                   "total_posts" => <Number>,
      #                   "total_pages" => <Number>,
      #                   "previous_page" => <Number>,
      #                   "next_page" => <Number> }}
      def paginate(site, page)
        all_posts = site.site_payload['site']['posts']
        pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
        (1..pages).each do |num_page|
          pager = Pager.new(site, num_page, all_posts, pages)
          if num_page > 1
            newpage = Page.new(site, site.source, page.dir, page.name)
            newpage.pager = pager
            newpage.dir = Pager.paginate_path(site, num_page)
            site.pages << newpage
          else
            page.pager = pager
          end
        end
      end

      # Static: Fetch the URL of the template page. Used to determine the
      #         path to the first pager in the series.
      #
      # site - the Jekyll::Site object
      #
      # Returns the url of the template page
      def self.first_page_url(site)
        if page = Pagination.new.template_page(site)
          page.url
        else
          nil
        end
      end

      # Public: Find the Jekyll::Page which will act as the pager template
      #
      # site - the Jekyll::Site object
      #
      # Returns the Jekyll::Page which will act as the pager template
      def template_page(site)
        site.pages.dup.select do |page|
          Pager.pagination_candidate?(site.config, page)
        end.sort do |one, two|
          two.path.size <=> one.path.size
        end.first
      end
    end
  end

  class Pager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
      :previous_page, :previous_page_path, :next_page, :next_page_path

    # Calculate the number of pages.
    #
    # all_posts - The Array of all Posts.
    # per_page  - The Integer of entries per page.
    #
    # Returns the Integer number of pages.
    def self.calculate_pages(all_posts, per_page)
      (all_posts.size.to_f / per_page.to_i).ceil
    end

    # Determine if pagination is enabled the site.
    #
    # site - the Jekyll::Site object
    #
    # Returns true if pagination is enabled, false otherwise.
    def self.pagination_enabled?(site)
     !site.config['paginate'].nil? &&
       site.pages.size > 0
    end

    # Static: Determine if a page is a possible candidate to be a template page.
    #         Page's name must be `index.html` and exist in any of the directories
    #         between the site source and `paginate_path`.
    #
    # config - the site configuration hash
    # page   - the Jekyll::Page about which we're inquiring
    #
    # Returns true if the
    def self.pagination_candidate?(config, page)
      page_dir = File.dirname(File.expand_path(remove_leading_slash(page.path), config['source']))
      paginate_path = remove_leading_slash(config['paginate_path'])
      paginate_path = File.expand_path(paginate_path, config['source'])
      page.name == 'index.html' &&
        in_hierarchy(config['source'], page_dir, File.dirname(paginate_path))
    end

    # Determine if the subdirectories of the two paths are the same relative to source
    #
    # source        - the site source
    # page_dir      - the directory of the Jekyll::Page
    # paginate_path - the absolute paginate path (from root of FS)
    #
    # Returns whether the subdirectories are the same relative to source
    def self.in_hierarchy(source, page_dir, paginate_path)
      return false if paginate_path == File.dirname(paginate_path)
      return false if paginate_path == Pathname.new(source).parent
      page_dir == paginate_path ||
        in_hierarchy(source, page_dir, File.dirname(paginate_path))
    end

    # Static: Return the pagination path of the page
    #
    # site     - the Jekyll::Site object
    # num_page - the pagination page number
    #
    # Returns the pagination path as a string
    def self.paginate_path(site, num_page)
      return nil if num_page.nil?
      return Generators::Pagination.first_page_url(site) if num_page <= 1
      format = site.config['paginate_path']
      format = format.sub(':num', num_page.to_s)
      ensure_leading_slash(format)
    end

    # Static: Return a String version of the input which has a leading slash.
    #         If the input already has a forward slash in position zero, it will be
    #         returned unchanged.
    #
    # path - a String path
    #
    # Returns the path with a leading slash
    def self.ensure_leading_slash(path)
      path[0..0] == "/" ? path : "/#{path}"
    end

    # Static: Return a String version of the input without a leading slash.
    #
    # path - a String path
    #
    # Returns the input without the leading slash
    def self.remove_leading_slash(path)
      ensure_leading_slash(path)[1..-1]
    end

    # Initialize a new Pager.
    #
    # site     - the Jekyll::Site object
    # page      - The Integer page number.
    # all_posts - The Array of all the site's Posts.
    # num_pages - The Integer number of pages or nil if you'd like the number
    #             of pages calculated.
    def initialize(site, page, all_posts, num_pages = nil)
      @page = page
      @per_page = site.config['paginate'].to_i
      @total_pages = num_pages || Pager.calculate_pages(all_posts, @per_page)

      if @page > @total_pages
        raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
      end

      init = (@page - 1) * @per_page
      offset = (init + @per_page - 1) >= all_posts.size ? all_posts.size : (init + @per_page - 1)

      @total_posts = all_posts.size
      @posts = all_posts[init..offset]
      @previous_page = @page != 1 ? @page - 1 : nil
      @previous_page_path = Pager.paginate_path(site, @previous_page)
      @next_page = @page != @total_pages ? @page + 1 : nil
      @next_page_path = Pager.paginate_path(site, @next_page)
    end

    # Convert this Pager's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Pager.
    def to_liquid
      {
        'page' => page,
        'per_page' => per_page,
        'posts' => posts,
        'total_posts' => total_posts,
        'total_pages' => total_pages,
        'previous_page' => previous_page,
        'previous_page_path' => previous_page_path,
        'next_page' => next_page,
        'next_page_path' => next_page_path
      }
    end
  end
end
