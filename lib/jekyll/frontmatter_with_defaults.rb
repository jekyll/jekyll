# frozen_string_literal: true

require "forwardable"

module Jekyll
  class FrontmatterWithDefaults
    extend Forwardable

    def_delegators :to_h, :to_s, :to_a, :to_hash, :inspect

    def initialize(frontmatter_defaults, document, data)
      @frontmatter_defaults = frontmatter_defaults
      @document = document
      @data = data || {}
    end

    def method_missing(method, *args, &block)
      if @data.respond_to?(method)
        @data.public_send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method)
      @data.respond_to?(method) || super
    end

    def key?(key)
      @data.key?(key) || default_value_exists?(key)
    end

    def [](key)
      if @data.key?(key)
        @data[key]
      else
        lookup_default_value(key)
      end
    end

    def []=(key, value)
      @data[key] = value
    end

    def default_value_exists?(key)
      case @document
      when Jekyll::Document
        @frontmatter_defaults.key?(@document.relative_path, @document.collection.label, key)
      when Jekyll::Page
        @frontmatter_defaults.key?(File.join(@document.dir, @document.name), @document.type, key)
      else
        Jekyll.logger.debug "FrontMatterWithDefaults:",
          "unable to process document type #{document.class}"
      end
    end

    def lookup_default_value(key)
      case @document
      when Jekyll::Document
        @frontmatter_defaults.find(@document.relative_path, @document.collection.label, key)
      when Jekyll::Page
        @frontmatter_defaults.find(File.join(@document.dir, @document.name), @document.type, key)
      else
        Jekyll.logger.debug "FrontMatterWithDefaults:",
          "unable to process document type #{@document.class}"
      end
    end

    def all_default_values
      case @document
      when Jekyll::Document
        @frontmatter_defaults.all(@document.relative_path, @document.collection.label)
      when Jekyll::Page
        @frontmatter_defaults.all(File.join(@document.dir, @document.name), @document.type)
      else
        Jekyll.logger.debug "FrontMatterWithDefaults:",
          "unable to process document type #{@document.class}"
      end
    end

    def to_h
      all_default_values.merge(@data)
    end

    def default_proc
      nil
    end

    def default_proc=(*)
      nil
    end
  end
end
