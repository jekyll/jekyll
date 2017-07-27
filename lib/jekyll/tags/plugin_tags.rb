module Jekyll
  class PluginTags < Liquid::Tag
    def render(context); end
  end
end

TAGS = {
  "SeoTag"      => "seo",
  "FeedMetaTag" => "feed_meta",
}.freeze

TAGS.keys.each do |klass|
  Liquid::Template.register_tag(TAGS[klass], Class.new(Jekyll::PluginTags))
end
