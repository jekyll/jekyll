# frozen_string_literal: true

module Jekyll
  module Excerptible
    # The Document excerpt_separator, from the YAML Front-Matter or site
    # default excerpt_separator value
    #
    # Returns the document excerpt_separator
    def excerpt_separator
      (data["excerpt_separator"] || site.config["excerpt_separator"]).to_s
    end

    # Whether to generate an excerpt
    #
    # Returns true if the excerpt separator is configured.
    def generate_excerpt?
      !excerpt_separator.empty?
    end

    # Extract excerpt from the content
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
    def extract_excerpt
      head, _, tail = content.to_s.partition(excerpt_separator)

      # append appropriate closing tag (to a Liquid block), to the "head" if the
      # partitioning resulted in leaving the closing tag somewhere in the "tail"
      # partition.
      if head.include?("{%")
        head =~ %r!{%\s*(\w+).+\s*%}!
        tag_name = Regexp.last_match(1)

        if liquid_block?(tag_name) && head.match(%r!{%\s*end#{tag_name}\s*%}!).nil?
          print_build_warning
          head << "\n{% end#{tag_name} %}"
        end
      end

      if tail.empty?
        head
      else
        head.to_s.dup << "\n\n" << tail.scan(%r!^ {0,3}\[[^\]]+\]:.+$!).join("\n")
      end
    end

    private

    def generate_excerpt
      return unless generate_excerpt?
      data["excerpt"] ||= Jekyll::Excerpt.new(self)
    end

    def liquid_block?(tag_name)
      Liquid::Template.tags[tag_name].superclass == Liquid::Block
    end

    def print_build_warning
      Jekyll.logger.warn "Warning:", "Excerpt modified in #{relative_path}!"
      Jekyll.logger.warn "",
        "Found a Liquid block containing separator '#{excerpt_separator}' and has " \
        "been modified with the appropriate closing tag."
      Jekyll.logger.warn "",
        "Feel free to define a custom excerpt or excerpt_separator in the document's " \
        "Front Matter if the generated excerpt is unsatisfactory."
    end
  end
end
