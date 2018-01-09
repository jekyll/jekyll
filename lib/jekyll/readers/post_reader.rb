# frozen_string_literal: true

module Jekyll
  class PostReader
    attr_reader :site, :unfiltered_content
    include DocumentReader

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
  end
end
