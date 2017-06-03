module Jekyll::Filters
  module AssetTagFilters
    #
    # The following are supplementary filters meant to be used in conjuction with
    # Jekyll::Filters::URLFilters. They generate the corresponding HTML tag for
    # the provided asset file path, without additional validation.
    #
    # e.g. {{ "assets/main.css" | relative_url | stylesheet_tag }} would generate:
    #      <link rel='stylesheet' href='/blog/assets/main.css'>
    #      for a site with "baseurl" configured as "blog".
    #

    # Generates HTML <img> tag for the provided file.
    #
    # Accepts parameters to define image-attributes like alt-tag, width, and
    # class name(s). Height is always set to 'auto'. The parameters should be
    # provided in the following order:
    #
    #   alt-text > width > class(es)
    #
    def image_tag(input, alt = "", width = nil, klass = nil)
      unless width.nil?
        size = " width='#{width}' height='auto'"
      end
      unless klass.nil?
        klass = " class='#{klass}'"
      end
      "<img src='#{input}' alt='#{alt}'#{size}#{klass}>"
    end

    # Generates HTML <link> tag for the provided asset.
    #
    def stylesheet_tag(input)
      "<link rel='stylesheet' href='#{input}'>"
    end

    # Generates HTML <script></script> tag for the provided asset.
    #
    def script_tag(input)
      "<script src='#{input}'></script>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::Filters::AssetTagFilters)
