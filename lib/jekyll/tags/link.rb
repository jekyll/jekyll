# frozen_string_literal: true

module Jekyll
  module Tags
    class Link < Liquid::Tag
      include Jekyll::Filters::URLFilters

      class LinkRegistry
        def initialize
          @stash = {}
        end

        def [](key)
          @stash[ensure_single_leading_slash(key)]
        end

        def []=(key, value)
          @stash[ensure_single_leading_slash(key)] ||= ensure_single_leading_slash(value)
        end

        private

        # rubocop:disable Performance/DeletePrefix
        def ensure_single_leading_slash(input)
          result = input.nil? || input.empty? ? "" : input.gsub(%r!\A/!, "")
          "/#{result}"
        end
        # rubocop:enable Performance/DeletePrefix
      end
      private_constant :LinkRegistry

      # -- singleton methods -->

      class << self
        def tag_name
          name.split("::").last.downcase
        end

        def register_links(site)
          return unless site.is_a?(Jekyll::Site)

          # Ensure registry is reset on every call to __method__.
          registry = LinkRegistry.new

          site.each_site_file do |item|
            registry[item.relative_path] ||= Addressable::URI.parse(
              PathManager.join(site.config["baseurl"], item.url)
            ).normalize.to_s
          end

          @link_registry = registry
        end

        @link_registry ||= LinkRegistry.new
        attr_reader :link_registry
      end

      # -- instance methods -->

      def initialize(tag_name, relative_path, tokens)
        super

        @relative_path = relative_path.strip
      end

      def render(context)
        relative_path = Liquid::Template.parse(@relative_path).render(context)
        registry = Jekyll::Tags::Link.link_registry

        registry[relative_path] || raise(ArgumentError, <<~MSG)
          Could not find resource '#{relative_path}' in tag '#{self.class.tag_name}'.
          Make sure the resource exists and the path is correct.
        MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
