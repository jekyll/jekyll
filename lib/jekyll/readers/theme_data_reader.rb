# frozen_string_literal: true

module Jekyll
  class ThemeDataReader < Jekyll::DataReader
    attr_reader :site, :content

    def read(dir)
      return unless site.theme&.data_path

      base = site.in_theme_dir(dir)
      read_data_to(base, @content)
      Jekyll::Utils.deep_merge_hashes(@content, @site.data)
    end

    def read_data_to(dir, data)
      return unless File.directory?(dir) && !@entry_filter.symlink?(dir)

      entries = Dir.chdir(dir) do
        Dir["*.{yaml,yml,json,csv,tsv}"] + Dir["*"].select { |fn| File.directory?(fn) }
      end

      entries.each do |entry|
        path = @site.in_theme_dir(dir, entry)
        next if @entry_filter.symlink?(path)

        if File.directory?(path)
          read_data_to(path, data[sanitize_filename(entry)] = {})
        else
          key = sanitize_filename(File.basename(entry, ".*"))
          data[key] = read_data_file(path)
        end
      end
    end
  end
end
