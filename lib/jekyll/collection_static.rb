# frozen_string_literal: true

module Jekyll
  class CollectionStatic < StaticFile
    attr_reader :path, :collection

    def initialize(site, path, collection)
      @site = site
      @path = path
      @collection = collection
      @extname = File.extname(path)
      @name = File.basename(path)
      @data = @site.frontmatter_defaults.all(relative_path, type)
    end
    alias_method :output_ext, :extname

    def relative_path
      @relative_path ||= Pathname.new(path).relative_path_from(
        Pathname.new(@site.collections_path)
      ).to_s
    end

    def type
      @type ||= collection.label.to_sym
    end

    # TODO: Rename this method when Document#cleaned_relative_path is renamed
    def cleaned_relative_path
      @cleaned_relative_path ||=
        relative_path[0..-extname.length - 1].sub(collection.relative_directory, "")
    end

    # Applies a similar URL-building technique as Jekyll::Document that takes
    # the collection's URL template into account. The default URL template can
    # be overriden in the collection's configuration in _config.yml.
    def url
      @url ||= URL.new(
        :template     => url_template,
        :placeholders => url_placeholders
      ).to_s.chomp("/")
    end

    def url_placeholders
      @url_placeholders ||= Drops::UrlDrop.new(self)
    end

    def url_template
      collection.url_template.dup.tap do |template|
        template.chomp!("/")
        template << ":output_ext" unless template.end_with?(":output_ext")
      end
    end

    def destination_rel_dir
      File.dirname(url)
    end
  end
end
