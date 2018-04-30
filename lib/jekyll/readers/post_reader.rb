# frozen_string_literal: true

module Jekyll
  class PostReader
    attr_reader :site, :unfiltered_content
    def initialize(site)
      @site = site
    end

    # Read all the files in <source>/<dir>/_drafts and create a new
    # Document object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_drafts(dir)
      read_publishable(dir, "_drafts", Document::DATELESS_FILENAME_MATCHER)
    end

    # Read all the files in <source>/<dir>/_posts and create a new Document
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      read_publishable(dir, "_posts", Document::DATE_FILENAME_MATCHER)
    end

    # Read all the files in <source>/<dir>/<magic_dir> and create a new
    # Document object with each one insofar as it matches the regexp matcher.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_publishable(dir, magic_dir, matcher)
      read_content(dir, magic_dir, matcher).tap { |docs| docs.each(&:read) }
        .select do |doc|
          if doc.content.valid_encoding?
            site.publisher.publish?(doc).tap do |will_publish|
              if !will_publish && site.publisher.hidden_in_the_future?(doc)
                Jekyll.logger.debug "Skipping:", "#{doc.relative_path} has a future date"
              end
            end
          else
            Jekyll.logger.debug "Skipping:", "#{doc.relative_path} is not valid UTF-8"
            false
          end
        end
    end

    # Read all the content files from <source>/<dir>/magic_dir
    #   and return them with the type klass.
    #
    # dir - The String relative path of the directory to read.
    # magic_dir - The String relative directory to <dir>,
    #   looks for content here.
    # klass - The return type of the content.
    #
    # Returns klass type of content files
    def read_content(dir, magic_dir, matcher)
      @site.reader.get_entries(dir, magic_dir).map do |entry|
        next unless entry =~ matcher
        path = @site.in_source_dir(File.join(dir, magic_dir, entry))
        Document.new(path, {
          :site       => @site,
          :collection => @site.posts,
        })
      end.reject(&:nil?)
    end
  end
end
