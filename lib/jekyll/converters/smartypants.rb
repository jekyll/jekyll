# frozen_string_literal: true

class Kramdown::Parser::SmartyPants < Kramdown::Parser::Kramdown
  def initialize(source, options)
    super
    @block_parsers = [:block_html]
    @span_parsers =  [:smart_quotes, :html_entity, :typographic_syms, :span_html]
  end
end

module Jekyll
  module Converters
    class SmartyPants < Converter
      safe true
      priority :low

      def initialize(config)
        Jekyll::External.require_with_graceful_fail "kramdown"
        @config = config["kramdown"].dup || {}
        @config[:input] = :SmartyPants
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
