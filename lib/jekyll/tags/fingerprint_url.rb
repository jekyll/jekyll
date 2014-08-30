module Jekyll
  module Tags
    # Get access to the URL of a page with fingerprint in it's path
    class FingerprintUrl < Liquid::Tag
      def initialize(tag_name, path, _tokens)
        super
        @path = path.strip
      end

      def render(context)
        site = context.registers.fetch(:site)
        site.path_fingerprints.fetch(@path)
      end
    end
  end
end

Liquid::Template.register_tag('fingerprint_url', Jekyll::Tags::FingerprintUrl)
