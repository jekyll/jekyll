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
    alias_method :basename_without_ext, :basename

    def_delegators :doc, :date, :site, :collection

    def initialize(doc, dir, name)
      @doc = doc
      @data = {
        "categories" => doc.data["categories"],
      }
      @name = name
      @basename = File.basename(name, ".*")
      @extname = File.extname(name)
      @relative_path = PathManager.join(dir, name)
      @path = site.in_source_dir(@relative_path)
    end

    def to_liquid
      @to_liquid ||= Drops::AttachmentDrop.new(self)
    end

    def url
      @url ||= begin
        base = Jekyll::URL.new(
          :template     => "/:categories/:year/:month/:day/",
          :placeholders => Drops::UrlDrop.new(self)
        ).to_s
        base << doc_title_from_path
        base << "/"
        base << name
      end
    end

    def destination(dest)
      @destination ||= {}
      @destination[dest] ||= site.in_dest_dir(dest, Jekyll::URL.unescape_path(url))
    end

    def write(dest)
      dest_path = destination(dest)
      if File.exist?(dest_path)
        FileUtils.rm(dest_path)
      else
        FileUtils.mkdir_p(File.dirname(dest_path))
      end

      Jekyll.logger.info "Writing:", dest_path
      FileUtils.cp(path, dest_path)
    end

    def inspect
      "#<#{self.class} #{name.inspect} for #{@doc.relative_path.inspect}>"
    end
    alias_method :to_s, :inspect

    private

    POST_BASENAME_MATCHER = %r!(?:\d{2,4}-\d{1,2}-\d{1,2}-)+?(.*)!.freeze
    private_constant :POST_BASENAME_MATCHER

    def doc_title_from_path
      cleaned_doc_basename = File.basename(doc.cleaned_relative_path, ".*")
      return cleaned_doc_basename unless POST_BASENAME_MATCHER =~ cleaned_doc_basename

      Regexp.last_match[1]
    end
  end
end
