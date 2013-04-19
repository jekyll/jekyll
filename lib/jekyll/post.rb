module Jekyll
  class Post
    include Comparable
    include Convertible

    class << self
      attr_accessor :lsi
    end

    # Valid post name regex.
    MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/

    # Post name validator. Post filenames must be like:
    # 2008-11-05-my-awesome-post.textile
    #
    # Returns true if valid, false if not.
    def self.valid?(name)
      name =~ MATCHER
    end

    attr_accessor :site
    attr_accessor :data, :extracted_excerpt, :content, :output, :ext
    attr_accessor :date, :slug, :published, :tags, :categories

    attr_reader :name

    # Initialize this Post instance.
    #
    # site       - The Site.
    # base       - The String path to the dir containing the post file.
    # name       - The String filename of the post file.
    #
    # Returns the new Post.
    def initialize(site, source, dir, name)
      @site = site
      @dir = dir
      @base = self.containing_dir(source, dir)
      @name = name

      self.categories = dir.downcase.split('/').reject { |x| x.empty? }
      self.process(name)
      begin
        self.read_yaml(@base, name)
      rescue Exception => msg
        raise FatalException.new("#{msg} in #{@base}/#{name}")
      end

      # If we've added a date and time to the YAML, use that instead of the
      # filename date. Means we'll sort correctly.
      if self.data.has_key?('date')
        # ensure Time via to_s and reparse
        self.date = Time.parse(self.data["date"].to_s)
      end

      if self.data.has_key?('published') && self.data['published'] == false
        self.published = false
      else
        self.published = true
      end

      self.tags = self.data.pluralized_array("tag", "tags")

      if self.categories.empty?
        self.categories = self.data.pluralized_array('category', 'categories').map {|c| c.downcase}
      end

      self.tags.flatten!
      self.categories.flatten!
    end

    # Get the full path to the directory containing the post files
    def containing_dir(source, dir)
      return File.join(source, dir, '_posts')
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      super(base, name)
      self.extracted_excerpt = self.extract_excerpt
    end

    # The post excerpt. This is either a custom excerpt
    # set in YAML front matter or the result of extract_excerpt.
    #
    # Returns excerpt string.
    def excerpt
      if self.data.has_key? 'excerpt'
        self.data['excerpt']
      else
        self.extracted_excerpt
      end
    end

    # Compares Post objects. First compares the Post date. If the dates are
    # equal, it compares the Post slugs.
    #
    # other - The other Post we are comparing to.
    #
    # Returns -1, 0, 1
    def <=>(other)
      cmp = self.date <=> other.date
      if 0 == cmp
       cmp = self.slug <=> other.slug
      end
      return cmp
    end

    # Extract information from the post filename.
    #
    # name - The String filename of the post file.
    #
    # Returns nothing.
    def process(name)
      m, cats, date, slug, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
    rescue ArgumentError
      raise FatalException.new("Post #{name} does not have a valid date.")
    end

    # Transform the contents and excerpt based on the content type.
    #
    # Returns nothing.
    def transform
      super
      self.extracted_excerpt = converter.convert(self.extracted_excerpt)
    end

    # The generated directory into which the post will be placed
    # upon generation. This is derived from the permalink or, if
    # permalink is absent, set to the default date
    # e.g. "/2008/11/05/" if the permalink style is :date, otherwise nothing.
    #
    # Returns the String directory.
    def dir
      File.dirname(url)
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body (optional).
    #
    # Returns the String permalink.
    def permalink
      self.data && self.data['permalink']
    end

    def template
      case self.site.permalink_style
      when :pretty
        "/:categories/:year/:month/:day/:title/"
      when :none
        "/:categories/:title.html"
      when :date
        "/:categories/:year/:month/:day/:title.html"
      when :ordinal
        "/:categories/:year/:y_day/:title.html"
      else
        self.site.permalink_style.to_s
      end
    end

    # The generated relative url of this post.
    # e.g. /2008/11/05/my-awesome-post.html
    #
    # Returns the String URL.
    def url
      return @url if @url

      url = if permalink
        permalink
      else
        {
          "year"       => date.strftime("%Y"),
          "month"      => date.strftime("%m"),
          "day"        => date.strftime("%d"),
          "title"      => CGI.escape(slug),
          "i_day"      => date.strftime("%d").to_i.to_s,
          "i_month"    => date.strftime("%m").to_i.to_s,
          "categories" => categories.map { |c| URI.escape(c.to_s) }.join('/'),
          "short_month" => date.strftime("%b"),
          "y_day"      => date.strftime("%j"),
          "output_ext" => self.output_ext
        }.inject(template) { |result, token|
          result.gsub(/:#{Regexp.escape token.first}/, token.last)
        }.gsub(/\/\//, "/")
      end

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      @url += "/" if url =~ /\/$/
      @url.gsub!(/\A\//, '')
      @url
    end

    # The UID for this post (useful in feeds).
    # e.g. /2008/11/05/my-awesome-post
    #
    # Returns the String UID.
    def id
      File.join(self.dir, self.slug)
    end

    # Calculate related posts.
    #
    # Returns an Array of related Posts.
    def related_posts(posts)
      return [] unless posts.size > 1

      if self.site.lsi
        self.class.lsi ||= begin
          puts "Starting the classifier..."
          lsi = Classifier::LSI.new(:auto_rebuild => false)
          $stdout.print("  Populating LSI... ");$stdout.flush
          posts.each { |x| $stdout.print(".");$stdout.flush;lsi.add_item(x) }
          $stdout.print("\n  Rebuilding LSI index... ")
          lsi.build_index
          puts ""
          lsi
        end

        related = self.class.lsi.find_related(self.content, 11)
        related - [self]
      else
        (posts - [self])[0..9]
      end
    end

    # Add any necessary layouts to this post.
    #
    # layouts      - A Hash of {"name" => "layout"}.
    # site_payload - The site payload hash.
    #
    # Returns nothing.
    def render(layouts, site_payload)
      # construct payload
      payload = {
        "site" => { "related_posts" => related_posts(site_payload["site"]["posts"]) },
        "page" => self.to_liquid
      }.deep_merge(site_payload)

      do_layout(payload, layouts)
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns destination file path String.
    def destination(dest)
      # The url needs to be unescaped in order to preserve the correct filename
      path = File.join(dest, CGI.unescape(self.url))
      path = File.join(path, "index.html") if template[/\.html$/].nil?
      path
    end

    # Convert this post into a Hash for use in Liquid templates.
    #
    # Returns the representative Hash.
    def to_liquid
      self.data.deep_merge({
        "title"      => self.data["title"] || self.slug.split('-').select {|w| w.capitalize! || w }.join(' '),
        "url"        => self.url,
        "date"       => self.date,
        "id"         => self.id,
        "categories" => self.categories,
        "next"       => self.next,
        "previous"   => self.previous,
        "tags"       => self.tags,
        "content"    => self.content,
        "excerpt"    => self.excerpt,
        "path"       => self.data['path'] || File.join(@dir, '_posts', @name).sub(/\A\//, '') })
    end

    # Returns the shorthand String identifier of this Post.
    def inspect
      "<Post: #{self.id}>"
    end

    def next
      pos = self.site.posts.index(self)

      if pos && pos < self.site.posts.length-1
        self.site.posts[pos+1]
      else
        nil
      end
    end

    def previous
      pos = self.site.posts.index(self)
      if pos && pos > 0
        self.site.posts[pos-1]
      else
        nil
      end
    end

    protected

    # Internal: Extract excerpt from the content
    #
    # By default excerpt is your first paragraph of a post: everything before
    # the first two new lines:
    #
    #     ---
    #     title: Example
    #     ---
    #
    #     First paragraph with [link][1].
    #
    #     Second paragraph.
    #
    #     [1]: http://example.com/
    #
    # This is fairly good option for Markdown and Textile files. But might cause
    # problems for HTML posts (which is quite unusual for Jekyll). If default
    # excerpt delimiter is not good for you, you might want to set your own via
    # configuration option `excerpt_separator`. For example, following is a good
    # alternative for HTML posts:
    #
    #     # file: _config.yml
    #     excerpt_separator: "<!-- more -->"
    #
    # Notice that all markdown-style link references will be appended to the
    # excerpt. So the example post above will have this excerpt source:
    #
    #     First paragraph with [link][1].
    #
    #     [1]: http://example.com/
    #
    # Excerpts are rendered same time as content is rendered.
    #
    # Returns excerpt String
    def extract_excerpt
      separator     = self.site.config['excerpt_separator']
      head, _, tail = self.content.partition(separator)

      "" << head << "\n\n" << tail.scan(/^\[[^\]]+\]:.+$/).join("\n")
    end
  end
end
