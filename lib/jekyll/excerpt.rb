module Jekyll
  class Excerpt
    extend Forwardable

    attr_accessor :doc
    attr_accessor :content, :ext
    attr_writer   :output

    def_delegators :@doc, :site, :name, :ext, :relative_path, :extname,
                          :render_with_liquid?, :collection, :related_posts, :url

    # Initialize this Excerpt instance.
    #
    # doc - The Document.
    #
    # Returns the new Excerpt.
    def initialize(doc)
      self.doc = doc
      self.content = extract_excerpt(doc.content)
    end

    # Fetch YAML front-matter data from related doc, without layout key
    #
    # Returns Hash of doc data
    def data
      @data ||= doc.data.dup
      @data.delete("layout")
      @data.delete("excerpt")
      @data
    end

    def trigger_hooks(*)
    end

    # 'Path' of the excerpt.
    #
    # Returns the path for the doc this excerpt belongs to with #excerpt appended
    def path
      File.join(doc.path, "#excerpt")
    end

    # Check if excerpt includes a string
    #
    # Returns true if the string passed in
    def include?(something)
      (output && output.include?(something)) || content.include?(something)
    end

    # The UID for this doc (useful in feeds).
    # e.g. /2008/11/05/my-awesome-doc
    #
    # Returns the String UID.
    def id
      "#{doc.id}#excerpt"
    end

    def to_s
      output || content
    end

    def to_liquid
      Jekyll::Drops::ExcerptDrop.new(self)
    end

    # Returns the shorthand String identifier of this doc.
    def inspect
      "<Excerpt: #{self.id}>"
    end

    def output
      @output ||= Renderer.new(doc.site, self, site.site_payload).run
    end

    def place_in_layout?
      false
    end

    protected

    # Internal: Extract excerpt from the content
    #
    # By default excerpt is your first paragraph of a doc: everything before
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
    # problems for HTML docs (which is quite unusual for Jekyll). If default
    # excerpt delimiter is not good for you, you might want to set your own via
    # configuration option `excerpt_separator`. For example, following is a good
    # alternative for HTML docs:
    #
    #     # file: _config.yml
    #     excerpt_separator: "<!-- more -->"
    #
    # Notice that all markdown-style link references will be appended to the
    # excerpt. So the example doc above will have this excerpt source:
    #
    #     First paragraph with [link][1].
    #
    #     [1]: http://example.com/
    #
    # Excerpts are rendered same time as content is rendered.
    #
    # Returns excerpt String
    def extract_excerpt(doc_content)
      head, _, tail = doc_content.to_s.partition(doc.excerpt_separator)

      if tail.empty?
        head
      else
        "" << head << "\n\n" << tail.scan(/^\[[^\]]+\]:.+$/).join("\n")
      end
    end
  end
end
