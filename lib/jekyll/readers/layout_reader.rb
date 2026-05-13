# frozen_string_literal: true

module Jekyll
  class LayoutReader
    attr_reader :site

    def initialize(site)
      @site = site
      @layouts = {}
      @layout_variants = Hash.new { |hash, key| hash[key] = [] }
    end

    def read
      layout_entries.each do |layout_file|
        add_layout(layout_directory, layout_file, :overwrite)
      end

      theme_layout_entries.each do |layout_file|
        add_layout(theme_layout_directory, layout_file, :fallback)
      end

      site.layout_variants = @layout_variants
      @layouts
    end

    def layout_directory
      @layout_directory ||= site.in_source_dir(site.config["layouts_dir"])
    end

    def theme_layout_directory
      @theme_layout_directory ||= site.theme.layouts_path if site.theme
    end

    private

    def layout_entries
      entries_in layout_directory
    end

    def theme_layout_entries
      theme_layout_directory ? entries_in(theme_layout_directory) : []
    end

    def entries_in(dir)
      entries = []
      within(dir) do
        entries = EntryFilter.new(site).filter(Dir["**/*.*"])
      end
      entries
    end

    def add_layout(directory, layout_file, merge_strategy)
      name = layout_name(layout_file)
      layout = Layout.new(site, directory, layout_file)
      variants = @layout_variants[name]
      existing_index = variants.index { |variant| variant.ext == layout.ext }

      if existing_index
        variants[existing_index] = layout if merge_strategy == :overwrite
      else
        variants << layout
      end

      @layouts[name] = primary_layout_for(variants)
    end

    def primary_layout_for(layouts)
      layouts.find { |layout| Page::HTML_EXTENSIONS.include?(layout.ext) } || layouts.first
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def within(directory)
      return unless File.exist?(directory)

      Dir.chdir(directory) { yield }
    end
  end
end
