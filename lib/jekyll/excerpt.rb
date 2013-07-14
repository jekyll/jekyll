module Jekyll
  class Excerpt

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

    include Convertible

    attr_accessor :post
    attr_accessor :content, :output, :ext

    # Initialize this Post instance.
    #
    # site       - The Site.
    # base       - The String path to the dir containing the post file.
    # name       - The String filename of the post file.
    #
    # Returns the new Post.
    def initialize(post)
      @post = post
      @content = extract_excerpt(post.content)
    end

    %w[site name data ext].each do |meth|
      define_method(meth) do
        post.send(meth)
      end
    end

    def path
      File.join(post.path, "#excerpt")
    end

    def include?(something)
      (output && output.include?(something)) || content.include?(something)
    end

    # The UID for this post (useful in feeds).
    # e.g. /2008/11/05/my-awesome-post
    #
    # Returns the String UID.
    def id
      File.join(post.dir, post.slug, "#excerpt")
    end

    # Convert this post into a Hash for use in Liquid templates.
    #
    # Returns the representative Hash.
    def to_liquid
      post.to_liquid
    end

    def to_s
      output || content
    end

    # Returns the shorthand String identifier of this Post.
    def inspect
      "<Excerpt: #{self.id}>"
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
    def extract_excerpt(post_content)
      separator     = site.config['excerpt_separator']
      head, _, tail = post_content.partition(separator)

      "" << head << "\n\n" << tail.scan(/^\[[^\]]+\]:.+$/).join("\n")
    end
  end
end
