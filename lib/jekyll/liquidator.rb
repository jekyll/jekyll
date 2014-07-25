module Jekyll
  class Liquidator
    def initialize(object)
      @obj = object
    end

    # The liquid representation of what we're working with
    #
    # Returns a proper Liquid representation of the thing we're dealing with
    def to_liquid
      if @obj.is_a?(Jekyll::Site)
        site_to_liquid
      elsif @obj.eql?(Jekyll)
        jekyll_to_liquid
      elsif @obj.is_a?(Jekyll::Document)
        document_to_liquid
      elsif @obj.respond_to?(:to_liquid)
        @obj.to_liquid
      else
        Hash[@obj.class.liquid_attributes.map do |attribute, attr_proc|
          [attribute, object.send(attribute)]
        end]
      end
    end

    # The Hash payload containing site-wide data.
    #
    # Returns the Hash: { "site" => data } where data is a Hash with keys:
    #   "time"       - The Time as specified in the configuration or the
    #                  current time if none was specified.
    #   "posts"      - The Array of Posts, sorted chronologically by post date
    #                  and then title.
    #   "pages"      - The Array of all Pages.
    #   "html_pages" - The Array of HTML Pages.
    #   "categories" - The Hash of category values and Posts.
    #                  See Site#post_attr_hash for type info.
    #   "tags"       - The Hash of tag values and Posts.
    #                  See Site#post_attr_hash for type info.
    def site_to_liquid
      Utils.deep_merge_hashes(
        config,
        Utils.deep_merge_hashes(
          Hash[collections.map{|label, coll| [label, coll.docs]}],
          {
            "time"         => @obj.time,
            "posts"        => @obj.posts.sort { |a, b| b <=> a },
            "pages"        => @obj.pages,
            "static_files" => @obj.static_files.sort { |a, b| a.relative_path <=> b.relative_path },
            "html_pages"   => @obj.pages.select { |page| page.html? || page.url.end_with?("/") },
            "categories"   => @obj.post_attr_hash('categories'),
            "tags"         => @obj.post_attr_hash('tags'),
            "collections"  => @obj.collections,
            "documents"    => @obj.documents,
            "data"         => @obj.site_data
          }
        )
      )
    end

    def jekyll_to_liquid
      {
        "version" => Jekyll::VERSION,
        "env"     => Jekyll.env
      }
    end

    def document_to_liquid
      Utils.deep_merge_hashes @obj.data, {
        "output"        => @obj.output,
        "content"       => @obj.content,
        "path"          => @obj.path,
        "relative_path" => @obj.relative_path,
        "url"           => @obj.url,
        "collection"    => @obj.collection.label
      }
    end
  end
end
