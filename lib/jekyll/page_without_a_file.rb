# frozen_string_literal: true

module Jekyll
  # A Jekyll::Page subclass to handle processing files without reading it to
  # determine the page-data and page-content based on Front Matter delimiters.
  #
  # The class instance is basically just a bare-bones entity with just
  # attributes "dir", "name", "path", "url" defined on it.
  class PageWithoutAFile < Page
    def read_yaml(*)
      @data ||= {}
    end

    def inspect
      "#<Jekyll:PageWithoutAFile @name=#{name.inspect}>"
    end
  end
end
