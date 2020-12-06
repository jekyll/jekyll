# frozen_string_literal: true

module Jekyll
  class TaxonomyManager < Generator
    safe :true

    def initialize(config)
      @config = config["taxonomy_pages"]
    end

    def generate(site)
      if @config["tags"] == "enabled"
        site.tags.each do |tag, docs|
          site.pages << Taxonomy::Page.new(site, "tag", tag, docs)
        end
      end

      if @config["categories"] == "enabled"
        site.categories.each do |category, docs|
          site.pages << Taxonomy::Page.new(site, "category", category, docs)
        end
      end

      nil
    end
  end
end
