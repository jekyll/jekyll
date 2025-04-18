# frozen_string_literal: true

module Jekyll
  module Drops
    class AttachmentDrop < Drop
      delegate_methods :basename, :extname, :name, :url
      delegate_method_as :relative_path, :path
      private delegate_method_as :data, :fallback_data
    end
  end

  class Attachment
    extend Forwardable

    attr_reader :doc, :data, :name, :basename, :extname, :relative_path, :path
    alias_method :basename_without_ext, :name

    def_delegators :doc, :date, :site, :collection

    def initialize(doc, dir, name)
      @doc = doc
      @data = {
        "categories" => doc.data["categories"]
      }
      @name = name
      @basename = File.basename(name, ".*")
      @extname = File.extname(name)
      @relative_path = PathManager.join(dir, name)
      @path = site.in_source_dir(@relative_path)
    end

    def url
      @url ||= Jekyll::URL.new(
        :template     => "/:categories/:year/:month/:day/",
        :placeholders => Drops::UrlDrop.new(self)
      ).to_s << name
    end

    def destination(dest)
      @destination ||= {}
      @destination[dest] ||= site.in_dest_dir(dest, Jekyll::URL.unescape_path(url))
    end

    def to_liquid
      to_liquid ||= Drops::AttachmentDrop.new(self)
    end

    def inspect
      "#<#{self.class} #{name.inspect} for #{@doc.relative_path.inspect}>"
    end
    alias_method :to_s, :inspect

    def write(dest)
      dest_path = destination(dest)
      return if File.exist?(dest_path)

      Jekyll.logger.info "Writing:", dest_path
      FileUtils.cp(path, dest_path)
    end
  end
end
