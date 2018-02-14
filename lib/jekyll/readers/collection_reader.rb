# frozen_string_literal: true

module Jekyll
  class CollectionReader
    attr_reader :site, :content

    def initialize(site)
      @site = site
      @content = {}
    end

    # Read in all collections specified in the configuration
    #
    # Returns nothing.
    def read(dir)
      retrieve_posts(dir)
      site.collections.each_value do |collection|
        next if collection.label == "posts"
        collection.docs.concat(read_documents(dir, collection.relative_directory))
      end
    end

    private

    def retrieve_posts(dir)
      site.posts.docs.concat(read_posts(dir))
      site.posts.docs.concat(read_documents(dir, "_drafts")) if site.show_drafts
    end

    def read_posts(dir)
      read_publishable(dir, "_posts", Document::DATE_FILENAME_MATCHER)
    end

    def read_documents(dir, collection_dir)
      read_publishable(dir, collection_dir, Document::DATELESS_FILENAME_MATCHER)
    end

    # Read all the files in <source>/<dir>/<magic_dir> and create a new Document
    # object as long as as the file matches the regexp matcher.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_publishable(dir, magic_dir, matcher)
      read_content(dir, magic_dir, matcher).tap do |docs|
        next if docs.empty?
        docs.each(&:read)
      end.select(&:publishable?)
    end

    # Read all the content files from <source>/<dir>/magic_dir and return them
    # with the type klass.
    #
    # dir - The String relative path of the directory to read.
    # magic_dir - The String relative directory to <dir>, looks for content here.
    # klass - The return type of the content.
    #
    # Returns klass type of content files
    def read_content(dir, magic_dir, matcher)
      label = label_from_dirname(magic_dir)
      collection = site.collections[label]

      site.reader.get_entries(dir, magic_dir).map do |entry|
        if label == "posts"
          next unless entry =~ matcher
        end

        path = site.in_source_dir(dir, magic_dir, entry)

        if Utils.has_yaml_header? path
          Document.new(path, {
            :site       => site,
            :collection => collection,
          })
        else
          retrieve_static_files(path, collection)
          nil
        end
      end.compact
    end

    def retrieve_static_files(file_path, collection)
      relative_dir = File.dirname(file_path).sub(
        site.in_source_dir(collection.send(:container), "/"), ""
      )

      collection.files << StaticFile.new(
        site, site.source, relative_dir, File.basename(file_path), collection
      )
    end

    def label_from_dirname(magic_dir)
      return magic_dir unless magic_dir.start_with?("_")
      return "posts" if magic_dir =~ %r!\A_(draf|pos)ts\Z!
      magic_dir.sub("_", "")
    end
  end
end
