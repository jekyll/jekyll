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

    def draft?
      !!data["draft"]
    end

    def do_nothing(*)
      nil
    end
    alias_method :process, :do_nothing
    alias_method :read, :do_nothing
    alias_method :read_content, :do_nothing
    alias_method :read_post_data, :do_nothing
    alias_method :categories_from_path, :do_nothing
    alias_method :populate_categories, :do_nothing
    alias_method :populate_tags, :do_nothing
    alias_method :backwards_compatibilize, :do_nothing
  end
end
