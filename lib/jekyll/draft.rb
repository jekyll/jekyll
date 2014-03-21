module Jekyll

  class Draft < Post

    # Valid post name regex (no date)
    MATCHER = /^(.*)(\.[^.]+)$/

    # Draft name validator. Draft filenames must be like:
    # my-awesome-post.textile
    #
    # Returns true if valid, false if not.
    def self.valid?(name)
      name =~ MATCHER
    end

    # Extract information from the post filename.
    #
    # name - The String filename of the post file.
    #
    # Returns nothing.
    def process(name)
      m, slug, ext = *name.match(MATCHER)
      self.date = File.mtime(self.file_path)
      self.slug = slug
      self.ext = ext
    end

  end

end
