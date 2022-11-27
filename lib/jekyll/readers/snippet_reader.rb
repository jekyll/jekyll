# frozen_string_literal: true

module Jekyll
  class SnippetReader
    def initialize(site)
      @site = site
    end

    def read
      read_dir_at_source if @site.snippets_at_source
      read_dir_in_theme if @site.theme&.snippets_path
    end

    private

    def read_dir(path)
      return unless File.directory?(path)

      Dir.chdir(path) do
        EntryFilter.new(@site, path).filter(Dir["**/*.*"]).each { |entry| yield entry }
      end
    end

    def read_dir_at_source
      read_dir(@site.in_source_dir(@site.config["snippets_dir"])) do |entry|
        @site.snippets[entry] = Snippet.new(@site, entry)
      end
    end

    def read_dir_in_theme
      read_dir(@site.theme.snippets_path) do |entry|
        @site.snippets[entry] ||= Snippet.new(@site, entry, @site.theme)
      end
    end
  end
end
