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
      @unfiltered_content = read_content(dir, '_drafts')
      @unfiltered_content.select{ |draft| site.publisher.publish?(draft) }
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
    def read_content(dir, magic_dir)
      @site.reader.get_entries(dir, magic_dir).map do |entry|
        Draft.new(site, site.source, dir, entry) if Draft.valid?(entry)
      end.reject do |entry|
        entry.nil?
      end
    end
  end
end
