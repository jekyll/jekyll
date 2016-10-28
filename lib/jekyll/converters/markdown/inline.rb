class Kramdown::Parser::Inline < Kramdown::Parser::Kramdown
  def initialize(source, options)
    super
    @block_parsers = [:block_html].freeze
  end
end

module Jekyll
  module Converters
    class Markdown
      class Inline < Converter
        safe true
        priority :low

        def initialize(config)
          Jekyll::External.require_with_graceful_fail "kramdown"
          @config = config["kramdown"].dup || {}
          @config[:input] = :Inline
        end

        def matches(_)
          false
        end

        def output_ext(_)
          nil
        end

        def convert(content)
          Kramdown::Document.new(content, @config).to_html.chomp
        end
      end
    end
  end
end
