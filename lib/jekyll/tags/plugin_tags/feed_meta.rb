module Jekyll
  module PluginTags
    class MetaTag < Liquid::Tag
      def render(context)
      end
    end
  end
end

Liquid::Template.register_tag("feed_meta", Jekyll::PluginTags::MetaTag)
