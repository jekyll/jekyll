module Jekyll
  class ThemeAssetsReader
    attr_reader :site
    def initialize(site)
      @site = site
    end

    def read
      return unless site.theme && site.theme.assets_path

      Find.find(site.theme.assets_path) do |path|
        next if File.directory?(path)
        if File.symlink?(path)
          Jekyll.logger.warn "Theme reader:", "Ignored symlinked asset: #{path}"
        else
          base = site.theme.root
          dir = File.dirname(path.sub("#{site.theme.root}/", ""))
          name = File.basename(path)
          relative_path = File.join(*[dir, name].compact)
          if Utils.has_yaml_header?(path)
            next if site.pages.any? { |file| file.relative_path == relative_path }
            site.pages << Jekyll::Page.new(site, base, dir, name)
          else
            next if site.static_files.any? { |file| file.relative_path == relative_path }
            site.static_files << Jekyll::StaticFile.new(site, base, dir, name)
          end
        end
      end
    end
  end
end
