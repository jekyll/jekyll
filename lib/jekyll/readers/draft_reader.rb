module Jekyll
  class DraftReader
    attr_reader :site, :unfiltered_content
    def initialize(site)
      @site = site
      @unfiltered_content = Array.new
    end

    # Read all the files in <source>/<dir>/_drafts and create a new Draft
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read(dir)
      @unfiltered_content = @site.reader.read_content(dir, '_drafts', Draft)
      @unfiltered_content.select{ |draft| site.publisher.publish?(draft) }
    end
  end
end
