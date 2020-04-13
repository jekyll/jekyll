# frozen_string_literal: true

module Jekyll
  class Excerpt
    extend Forwardable

    attr_accessor :doc
    attr_accessor :content, :ext
    attr_writer   :output

    def_delegators :@doc,
                   :site, :name, :ext, :extname,
                   :collection, :related_posts, :type,
                   :coffeescript_file?, :yaml_file?,
                   :url, :next_doc, :previous_doc

    private :coffeescript_file?, :yaml_file?

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

    def trigger_hooks(*); end

    # 'Path' of the excerpt.
    #
    # Returns the path for the doc this excerpt belongs to with #excerpt appended
    def path
      File.join(doc.path, "#excerpt")
    end

    # 'Relative Path' of the excerpt.
    #
    # Returns the relative_path for the doc this excerpt belongs to with #excerpt appended
    def relative_path
      @relative_path ||= File.join(doc.relative_path, "#excerpt")
    end

    # Check if excerpt includes a string
    #
    # Returns true if the string passed in
    def include?(something)
      output&.include?(something) || content.include?(something)
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
      "<#{self.class} id=#{id}>"
    end

    def output
      @output ||= Renderer.new(doc.site, self, site.site_payload).run
    end

    def place_in_layout?
      false
    end

    def render_with_liquid?
      return false if data["render_with_liquid"] == false

      !(coffeescript_file? || yaml_file? || !Utils.has_liquid_construct?(content))
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

    LIQUID_TAG_REGEX = %r!{%-?\s*(\w+)\s*.*?-?%}!m.freeze
    MKDWN_LINK_REF_REGEX = %r!^ {0,3}(?:(\[[^\]]+\])(:.+))$!.freeze

    def extract_excerpt(doc_content)
      head, _, tail = doc_content.to_s.partition(doc.excerpt_separator)
      return head if tail.empty?

      head = sanctify_liquid_tags(head) if head.include?("{%")
      definitions = extract_markdown_link_reference_defintions(head, tail)
      return head if definitions.empty?

      head << "\n\n" << definitions.join("\n")
    end

    private

    # append appropriate closing tag(s) (for each Liquid block), to the `head` if the
    # partitioning resulted in leaving the closing tag somewhere in the `tail` partition.
    def sanctify_liquid_tags(head)
      modified  = false
      tag_names = head.scan(LIQUID_TAG_REGEX)
      tag_names.flatten!
      tag_names.reverse_each do |tag_name|
        next unless liquid_block?(tag_name)
        next if endtag_regex_stash(tag_name).match?(head)

        modified = true
        head << "\n{% end#{tag_name} %}"
      end

      print_build_warning if modified
      head
    end

    def extract_markdown_link_reference_defintions(head, tail)
      [].tap do |definitions|
        tail.scan(MKDWN_LINK_REF_REGEX).each do |segments|
          definitions << segments.join if head.include?(segments[0])
        end
      end
    end

    def endtag_regex_stash(tag_name)
      @endtag_regex_stash ||= {}
      @endtag_regex_stash[tag_name] ||= %r!{%-?\s*end#{tag_name}.*?\s*-?%}!m
    end

    def liquid_block?(tag_name)
      return false unless tag_name.is_a?(String)
      return false unless Liquid::Template.tags[tag_name]

      Liquid::Template.tags[tag_name].ancestors.include?(Liquid::Block)
    rescue NoMethodError
      Jekyll.logger.error "Error:",
                          "A Liquid tag in the excerpt of #{doc.relative_path} couldn't be parsed."
      raise
    end

    def print_build_warning
      Jekyll.logger.warn "Warning:", "Excerpt modified in #{doc.relative_path}!"
      Jekyll.logger.warn "", "Found a Liquid block containing the excerpt separator" \
                         " #{doc.excerpt_separator.inspect}. "
      Jekyll.logger.warn "", "The block has been modified with the appropriate closing tag."
      Jekyll.logger.warn "", "Feel free to define a custom excerpt or excerpt_separator in the"
      Jekyll.logger.warn "", "document's Front Matter if the generated excerpt is unsatisfactory."
    end
  end
end
