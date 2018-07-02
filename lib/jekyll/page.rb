# frozen_string_literal: true

module Jekyll
  class Page < Document
    attr_writer :dir
    attr_accessor :pager

    alias_method :ext, :extname
    alias_method :name, :basename
    alias_method :process, :read

    # Attributes for Liquid templates
    ATTRIBUTES_FOR_LIQUID = %w(
      content
      dir
      name
      path
      url
    ).freeze

    # rubocop:disable Metrics/AbcSize
    # Initialize a new Page.
    #
    # site - The Site object.
    # base - The String path to the source.
    # dir  - The String path between the source and the file.
    # name - The String filename of the file.
    def initialize(*args)
      if args.size == 2 # Initialized as Document
        super
      elsif args.size == 4 # Legacy Page support
        Jekyll::Deprecator.deprecation_message "Pages are now Documents."
        Jekyll::Deprecator.deprecation_message "Called by #{caller(1..1).first}."
        @site, @base, @dir, @name = args
        @path = if site.in_theme_dir(@base) == @base # we're in a theme
                  site.in_theme_dir(@base, @dir, @name)
                else
                  site.in_source_dir(@base, @dir, @name)
                end
        @relative_path = File.join(*[@dir, @name].map(&:to_s).reject(&:empty?)).sub(%r!\A\/!, "")
        super(@path, :collection => site.pages, :site => @site)
        read
        backwards_compatibilize
      else
        raise ArugmentError, "Expected 2 or 4 arguments, #{args.size} given"
      end
    end

    # rubocop:enable Metrics/AbcSize

    # Backwards compatible shim to return the generated directory into which
    # the page will be placed upon generation. This is derived from the
    # permalink or, if permalink is absent, will be '/'
    def dir
      if url.end_with?("/")
        url
      else
        url_dir = File.dirname(url)
        url_dir.end_with?("/") ? url_dir : "#{url_dir}/"
      end
    end

    # The template of the permalink.
    #
    # Returns the template String.
    def url_template
      if !html?
        "/:path:output_ext"
      elsif index?
        "/:relative_path_without_basename/"
      else
        Utils.add_permalink_suffix("/:path", site.permalink_style)
      end
    end
    alias_method :template, :url_template

    # Backwards compatible shim to add any necessary layouts to this post
    #
    # layouts      - The Hash of {"name" => "layout"}.
    # site_payload - The site payload Hash.
    #
    # Returns String rendered page.
    def render(_, site_payload = nil)
      Jekyll::Renderer.new(site, self, site_payload).run
    end

    # To maintain backwards compataiblity, path is relative for Pages
    # but absolute for documents. Use #absolute_path to get the absolute path
    def path
      Jekyll::Deprecator.deprecation_message "Page#path is now Page#relative_path."
      Jekyll::Deprecator.deprecation_message "Called by #{caller(1..1).first}."
      relative_path
    end

    private

    def backwards_compatibilize
      ATTRIBUTES_FOR_LIQUID.each do |key|
        data[key] = public_send(key.to_sym)
      end
      @url = nil
    end
  end
end
