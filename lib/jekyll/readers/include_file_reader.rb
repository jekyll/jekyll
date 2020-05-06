# frozen_string_literal: true

module Jekyll
  class IncludeFileReader
    attr_reader :site
    def initialize(site)
      @site = site
    end

    def read
      site.includes_load_paths.each do |load_path|
        entries_in(load_path)&.each do |name|
          inclusion = initialize_validated(load_path, name)
          inclusion && site.inclusions[name] ||= inclusion
        end
      end
    end

    private

    def initialize_validated(load_path, name)
      path = PathManager.join(load_path, name)
      return unless valid_include_path?(load_path, path)

      Inclusion.new(site, load_path, name)
    end

    def valid_include_path?(directory, path)
      !outside_scope(directory, path) && !File.directory?(path)
    end

    def outside_scope(directory, path)
      site.safe && !realpath_prefixed_with?(directory, path)
    end

    def realpath_prefixed_with?(dir, path)
      File.exist?(path) && File.realpath(path).start_with?(dir)
    rescue StandardError
      false
    end

    def entries_in(directory)
      entries = nil
      return entries unless File.exist?(directory)

      Dir.chdir(directory) { entries = Dir["**/*"] }
      entries
    end
  end
end
