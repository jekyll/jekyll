# frozen_string_literal: true

module Jekyll
  class ThemeAssetsReader
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def read
      site.theme&.inheritance_chain&.each do |layer|
        next unless layer.assets_path

        Find.find(layer.assets_path) do |path|
          next if File.directory?(path)

          if File.symlink?(path)
            Jekyll.logger.warn "Theme reader:", "Ignored symlinked asset: #{path}"
          else
            read_theme_asset(path, layer)
          end
        end
      end
    end

    private

    def read_theme_asset(path, theme = site.theme)
      base = theme.root
      dir = File.dirname(path.sub("#{theme.root}/", ""))
      name = File.basename(path)

      if Utils.has_yaml_header?(path)
        append_unless_exists site.pages,
                             Jekyll::Page.new(site, base, dir, name)
      else
        append_unless_exists site.static_files,
                             Jekyll::StaticFile.new(site, base, "/#{dir}", name)
      end
    end

    def append_unless_exists(haystack, new_item)
      if (site.pages + site.static_files).any? do |file|
        file.relative_path.delete_prefix("/") == new_item.relative_path.delete_prefix("/")
      end
        Jekyll.logger.debug "Theme:",
                            "Ignoring #{new_item.relative_path} in theme due to existing file " \
                            "with that path in site."
        return
      end

      haystack << new_item
    end
  end
end
