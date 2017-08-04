module Jekyll
  PLUGIN_TAGS = {
    "SeoTag"      => "seo",
    "FeedMetaTag" => "feed_meta",
  }.freeze

  class PluginTags < Liquid::Tag
    def render(context); end
  end
end

Jekyll::PLUGIN_TAGS.keys.each do |klass|
  Liquid::Template.register_tag(
    Jekyll::PLUGIN_TAGS[klass], Class.new(Jekyll::PluginTags)
  )
end
