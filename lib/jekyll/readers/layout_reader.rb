# frozen_string_literal: true

module Jekyll
  class LayoutReader
    attr_reader :site

    def initialize(site)
      @site = site
      @layouts = {}
    end

    def read
      layout_entries.each do |layout_file|
        add_layout(layout_directory, layout_file, :replace)
      end

      theme_layout_entries.each do |layout_file|
        add_layout(theme_layout_directory, layout_file, :keep)
      end

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

    def add_layout(directory, file, strategy)
      layout = Layout.new(site, directory, file)
      add_format_layout(file, layout, strategy)
      add_named_layout(file, layout, strategy)
    end

    def add_format_layout(file, layout, strategy)
      return if html_layout?(file)

      @layouts[file] = layout if strategy == :replace || !@layouts.key?(file)
    end

    def add_named_layout(file, layout, strategy)
      name = layout_name(file)
      if strategy == :replace
        @layouts[name] = layout if html_layout?(file) || !@layouts.key?(name)
        return
      end

      if !@layouts.key?(name) || (html_layout?(file) && !Utils.html_output_ext?(@layouts[name].ext))
        @layouts[name] = layout
      end
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def html_layout?(file)
      Utils.html_output_ext?(File.extname(file))
    end

    def within(directory)
      return unless File.exist?(directory)

      Dir.chdir(directory) { yield }
    end
  end
end
