module Jekyll
  module PluginTags
    def render(context); end
  end

  class FeedMetaTag < Liquid::Tag
  end

  class SeoTag < Liquid::Tag
  end
end

#

plugin_tags = [
  {
    "tag_name"  => "feed_meta",
    "tag_class" => Jekyll::FeedMetaTag,
  },
  {
    "tag_name"  => "seo",
    "tag_class" => Jekyll::SeoTag,
  },
]

#

plugin_tags.each do |tag|
  tag["tag_class"].include Jekyll::PluginTags
  Liquid::Template.register_tag(tag["tag_name"], tag["tag_class"])
end
