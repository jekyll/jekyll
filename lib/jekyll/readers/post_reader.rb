module Jekyll
  class PostReader
    attr_reader :site, :unfiltered_content
    def initialize(site)
      @site = site
      @unfiltered_content = Array.new
    end

    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read(dir)
      @unfiltered_content = @site.reader.read_content(dir, '_posts', Post)
      @unfiltered_content.select{ |post| site.publisher.publish?(post) }
    end
  end
end
