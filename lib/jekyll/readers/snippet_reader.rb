# frozen_string_literal: true

module Jekyll
  class SnippetReader
    def initialize(site)
      @site = site
      @dir_at_source = site.in_source_dir(site.config["snippets_dir"])
      @entry_filter = EntryFilter.new(site, @dir_at_source)
    end

    def read
      Dir.chdir(@dir_at_source) do
        filter_entries.each do |entry|
          @site.snippets[entry] = Snippet.new(@site, entry)
        end
      end
      return unless @site.theme

      Dir.chdir(@site.theme.snippets_path) do
        filter_entries.each do |entry|
          @site.snippets[entry] ||= Snippet.new(@site, entry, @site.theme)
        end
      end
    end

    private

    def filter_entries
      EntryFilter.new(@site).filter(Dir["**/*.*"])
    end
  end
end
