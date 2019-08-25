# frozen_string_literal: true

module Jekyll
  class StaticFileReader
    attr_reader :site, :dir, :unfiltered_content
    def initialize(site, dir)
      @site = site
      @dir = dir
      @unfiltered_content = []
    end

    # Create a new StaticFile object for every entry in a given list of basenames.
    #
    # files - an array of file basenames.
    #
    # Returns an array of static files.
    def read(files)
      files.each do |file|
        @unfiltered_content << StaticFile.new(@site, @site.source, @dir, file)
      end
      @unfiltered_content
    end
  end
end
