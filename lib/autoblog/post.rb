module AutoBlog

  class Post
    include Comparable
    include Convertible
    
    MATCHER = /^(\d+-\d+-\d+)-(.*)(\.[^.]+)$/
    
    # Post name validator. Post filenames must be like:
    #   2008-11-05-my-awesome-post.textile
    #
    # Returns <Bool>
    def self.valid?(name)
      name =~ MATCHER
    end
    
    attr_accessor :date, :slug, :ext
    attr_accessor :data, :content, :output
    
    # Initialize this Post instance.
    #   +base+ is the String path to the dir containing the post file
    #   +name+ is the String filename of the post file
    #
    # Returns <Post>
    def initialize(base, name)
      @base = base
      @name = name
      
      self.process(name)
      self.read_yaml(base, name)
      self.set_defaults
      self.transform
    end
    
    # Spaceship is based on Post#date
    #
    # Returns -1, 0, 1
    def <=>(other)
      self.date <=> other.date
    end
    
    # Extract information from the post filename
    #   +name+ is the String filename of the post file
    #
    # Returns nothing
    def process(name)
      m, date, slug, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
    end
    
    # The generated directory into which the post will be placed
    # upon generation. e.g. "/2008/11/05/"
    #
    # Returns <String>
    def dir
      self.date.strftime("/%Y/%m/%d/")
    end
    
    # The generated relative url of this post
    # e.g. /2008/11/05/my-awesome-post.html
    #
    # Returns <String>
    def url
      self.dir + self.slug + ".html"
    end
    
    # The UID for this post (useful in feeds)
    # e.g. /2008/11/05/my-awesome-post
    #
    # Returns <String>
    def id
      self.dir + self.slug
    end
    
    # Set the data defaults.
    #
    # Returns nothing
    def set_defaults
      self.data["layout"] ||= "default"
    end
    
    # Calculate related posts.
    #
    # Returns [<Post>]
    def related_posts(posts)
      related = posts - [self]
    end
    
    # Add any necessary layouts to this post
    #   +layouts+ is a Hash of {"name" => "layout"}
    #   +site_payload+ is the site payload hash
    #
    # Returns nothing
    def add_layout(layouts, site_payload)
      related = related_posts(site_payload["site"]["posts"])
      
      payload = {"page" => self.data, "related_posts" => related}.merge(site_payload)
      self.content = Liquid::Template.parse(self.content).render(payload, [AutoBlog::Filters])
      
      layout = layouts[self.data["layout"]] || self.content
      payload = {"content" => self.content, "page" => self.data}
      
      self.output = Liquid::Template.parse(layout).render(payload, [AutoBlog::Filters])
    end
    
    # Write the generated post file to the destination directory.
    #   +dest+ is the String path to the destination dir
    #
    # Returns nothing
    def write(dest)
      FileUtils.mkdir_p(File.join(dest, self.dir))
      
      path = File.join(dest, self.url)
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
    
    # Convert this post into a Hash for use in Liquid templates.
    #
    # Returns <Hash>
    def to_liquid
      { "title" => self.data["title"] || "",
        "url" => self.url,
        "date" => self.date,
        "id" => self.id,
        "content" => self.content }
    end
  end

end