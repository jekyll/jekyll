module Jekyll
  class Post
    include Comparable
    include Convertible

    # Valid post name regex.
    MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/

    EXCERPT_ATTRIBUTES_FOR_LIQUID = %w[
      title
      url
      dir
      date
      id
      categories
      next
      previous
      tags
      path
    ]

    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = EXCERPT_ATTRIBUTES_FOR_LIQUID + %w[
      content
      excerpt
      excerpt_separator
    ]

    # Post name validator. Post filenames must be like:
    # 2008-11-05-my-awesome-post.textile
    #
    # Returns true if valid, false if not.
    def self.valid?(name)
      name =~ MATCHER
    end

    attr_accessor :site
    attr_accessor :data, :extracted_excerpt, :content, :output, :ext
    attr_accessor :date, :slug, :tags, :categories

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
      @base = containing_dir(dir)
      @name = name

      self.categories = dir.split('/').reject { |x| x.empty? }
      process(name)
      read_yaml(@base, name)

      data.default_proc = proc do |hash, key|
        site.frontmatter_defaults.find(relative_path, type, key)
      end

      if data.key?('date')
        self.date = Utils.parse_date(data["date"].to_s, "Post '#{relative_path}' does not have a valid date in the YAML front matter.")
      end

      populate_categories
      populate_tags
    end

    def published?
      if data.key?('published') && data['published'] == false
        false
      else
        true
      end
    end

    def populate_categories
      categories_from_data = Utils.pluralized_array_from_hash(data, 'category', 'categories')
      self.categories = (
        Array(categories) + categories_from_data
      ).map { |c| c.to_s }.flatten.uniq
    end

    def populate_tags
      self.tags = Utils.pluralized_array_from_hash(data, "tag", "tags").flatten
    end

    # Get the full path to the directory containing the post files
    def containing_dir(dir)
      site.in_source_dir(dir, '_posts')
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      super(base, name)
      self.extracted_excerpt = extract_excerpt
    end

    # The post excerpt. This is either a custom excerpt
    # set in YAML front matter or the result of extract_excerpt.
    #
    # Returns excerpt string.
    def excerpt
      data.fetch('excerpt') { extracted_excerpt.to_s }
    end

    # Public: the Post title, from the YAML Front-Matter or from the slug
    #
    # Returns the post title
    def title
      data.fetch('title') { titleized_slug }
    end

    # Public: the Post excerpt_separator, from the YAML Front-Matter or site default
    #         excerpt_separator value
    #
    # Returns the post excerpt_separator
    def excerpt_separator
      (data['excerpt_separator'] || site.config['excerpt_separator']).to_s
    end

    # Turns the post slug into a suitable title
    def titleized_slug
      slug.split('-').select {|w| w.capitalize! || w }.join(' ')
    end

    # Public: the path to the post relative to the site source,
    #         from the YAML Front-Matter or from a combination of
    #         the directory it's in, "_posts", and the name of the
    #         post file
    #
    # Returns the path to the file relative to the site source
    def path
      data.fetch('path') { relative_path.sub(/\A\//, '') }
    end

    # The path to the post source file, relative to the site source
    def relative_path
      File.join(*[@dir, "_posts", @name].map(&:to_s).reject(&:empty?))
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
      self.date = Utils.parse_date(date, "Post '#{relative_path}' does not have a valid date in the filename.")
      self.slug = slug
      self.ext = ext
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
      data && data['permalink']
    end

    def template
      case site.permalink_style
      when :pretty
        "/:categories/:year/:month/:day/:title/"
      when :none
        "/:categories/:title.html"
      when :date
        "/:categories/:year/:month/:day/:title.html"
      when :ordinal
        "/:categories/:year/:y_day/:title.html"
      else
        site.permalink_style.to_s
      end
    end

    # The generated relative url of this post.
    #
    # Returns the String url.
    def url
      @url ||= URL.new({
        :template => template,
        :placeholders => url_placeholders,
        :permalink => permalink
      }).to_s
    end

    # Returns a hash of URL placeholder names (as symbols) mapping to the
    # desired placeholder replacements. For details see "url.rb"
    def url_placeholders
      {
        :year        => date.strftime("%Y"),
        :month       => date.strftime("%m"),
        :day         => date.strftime("%d"),
        :title       => slug,
        :i_day       => date.strftime("%-d"),
        :i_month     => date.strftime("%-m"),
        :categories  => (categories || []).map { |c| c.to_s.downcase }.uniq.join('/'),
        :short_month => date.strftime("%b"),
        :short_year  => date.strftime("%y"),
        :y_day       => date.strftime("%j"),
        :output_ext  => output_ext
      }
    end

    # The UID for this post (useful in feeds).
    # e.g. /2008/11/05/my-awesome-post
    #
    # Returns the String UID.
    def id
      File.join(dir, slug)
    end

    # Calculate related posts.
    #
    # Returns an Array of related Posts.
    def related_posts(posts)
      Jekyll::RelatedPosts.new(self).build
    end

    # Add any necessary layouts to this post.
    #
    # layouts      - A Hash of {"name" => "layout"}.
    # site_payload - The site payload hash.
    #
    # Returns nothing.
    def render(layouts, site_payload)
      # construct payload
      payload = Utils.deep_merge_hashes({
        "site" => { "related_posts" => related_posts(site_payload["site"]["posts"]) },
        "page" => to_liquid(self.class::EXCERPT_ATTRIBUTES_FOR_LIQUID)
      }, site_payload)

      if generate_excerpt?
        extracted_excerpt.do_layout(payload, {})
      end

      do_layout(payload.merge({"page" => to_liquid}), layouts)
    end

    # Obtain destination path.
    #
    # dest - The String path to the destination dir.
    #
    # Returns destination file path String.
    def destination(dest)
      # The url needs to be unescaped in order to preserve the correct filename
      path = site.in_dest_dir(dest, URL.unescape_path(url))
      path = File.join(path, "index.html") if self.url =~ /\/$/
      path
    end

    # Returns the shorthand String identifier of this Post.
    def inspect
      "<Post: #{id}>"
    end

    def next
      pos = site.posts.index {|post| post.equal?(self) }
      if pos && pos < site.posts.length - 1
        site.posts[pos + 1]
      else
        nil
      end
    end

    def previous
      pos = site.posts.index {|post| post.equal?(self) }
      if pos && pos > 0
        site.posts[pos - 1]
      else
        nil
      end
    end

    protected

    def extract_excerpt
      if generate_excerpt?
        Jekyll::Excerpt.new(self)
      else
        ""
      end
    end

    def generate_excerpt?
      !excerpt_separator.empty?
    end
  end
end
