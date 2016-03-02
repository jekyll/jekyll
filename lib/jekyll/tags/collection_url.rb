module Jekyll
  module Tags
    class CollectionUrl < Liquid::Tag
      TagName = 'collection_url'
      MATCHER = /^([\w-]+)\s+\/?(.*)$/

      def initialize(tag_name, markup, tokens)
        super
        orig_markup = markup.strip
        all, @collection, @item_name = *orig_markup.match(MATCHER)
        unless all
          raise ArgumentError.new <<-eos
Could not parse the collection or item "#{markup}" in tag '#{TagName}'.

Valid syntax: #{TagName} <collection> <item>
eos
        end

        @path_regex = /^\/#{@item_name}$/
      end

      def render(context)
        site = context.registers[:site]

        if site.collections[@collection]
          site.collections[@collection].docs.each do |p|
            return p.url if p.cleaned_relative_path.match(@path_regex)
          end

          raise ArgumentError.new <<-eos
Could not find item "#{@item_name}" in collection "#{@collection}" in tag '#{TagName}'.

Make sure the item exists and the name is correct.
eos
        else
          raise ArgumentError.new <<-eos
Could not find collection "#{@collection}" in tag '#{TagName}'

Make sure the collection exists and the name is correct.
eos
        end
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::CollectionUrl::TagName, Jekyll::Tags::CollectionUrl)
