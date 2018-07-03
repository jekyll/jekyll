# frozen_string_literal: true

module Jekyll
  class StaticFileReader
    attr_reader :site, :dir, :unfiltered_content
    def initialize(site, dir)
      @site = site
      @dir = dir
      @unfiltered_content = []
    end

    # Read all the files in <source>/<dir>/ for Yaml header and create a new Page
    # object for each file.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns an array of static files.
    def read(files)
      files.map do |file|
        @unfiltered_content << StaticFile.new(@site, @site.source, @dir, file)
      end
      @unfiltered_content
    end
  end
end
