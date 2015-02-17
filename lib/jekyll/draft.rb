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

    # Get the full path to the directory containing the draft files
    def containing_dir(dir)
      site.in_source_dir(dir, '_drafts')
    end

    # The path to the draft source file, relative to the site source
    def relative_path
      File.join(@dir, '_drafts', @name)
    end

    # Extract information from the post filename.
    #
    # name - The String filename of the post file.
    #
    # Returns nothing.
    def process(name)
      m, slug, ext = *name.match(MATCHER)
      self.date = File.mtime(File.join(@base, name))
      self.slug = slug
      self.ext = ext
    end

  end

end
