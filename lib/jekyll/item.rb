module Jekyll
  class Item
    include Convertible

    attr_accessor :site, :pager, :name, :ext, :basename, :data, :content, :output, :file_path

    # Initialize this Post instance.
    #
    # site       - The Site.
    # path       - The String path of the post file.
    #
    # Returns the new Post.
    def initialize(site, path)
      @file_path = path
      @site = site
      @name = File.basename(path)
      process(@name)
      read_yaml(path)
    end

    # Add any necessary layouts to this post.
    #
    # layouts      - A Hash of {"name" => "layout"}.
    # site_payload - The site payload hash.
    #
    # Returns nothing.
    def render(template, layouts, site_payload)
      payload = template.deep_merge(site_payload)
      do_layout(payload, layouts)
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body.
    #
    # Returns the String permalink or nil if none has been set.
    def permalink
      data && data['permalink']
    end
     
    # Returns the object as a debug String.
    def inspect
      "#<Jekyll:#{self.class.name} @name=#{self.name.inspect}>"
    end
  end
end
