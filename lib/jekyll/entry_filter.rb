# frozen_string_literal: true

module Jekyll
  class EntryFilter
    attr_reader :site

    SPECIAL_LEADING_CHAR_REGEX = %r!\A#{Regexp.union([".", "_", "#", "~"])}!o.freeze

    def initialize(site, base_directory = nil)
      @site = site
      @base_directory = derive_base_directory(
        @site, base_directory.to_s.dup
      )
    end

    def base_directory
      @base_directory.to_s
    end

    def derive_base_directory(site, base_dir)
      base_dir[site.source] = "" if base_dir.start_with?(site.source)
      base_dir
    end

    def relative_to_source(entry)
      File.join(
        base_directory, entry
      )
    end

    def filter(entries)
      entries.reject do |e|
        # Reject this entry if it is just a "dot" representation.
        #   e.g.: '.', '..', '_movies/.', 'music/..', etc
        next true if e.end_with?(".")

        # Check if the current entry is explicitly included and cache the result
        included = included?(e)

        # Reject current entry if it is excluded but not explicitly included as well.
        next true if excluded?(e) && !included

        # Reject current entry if it is a symlink.
        next true if symlink?(e)

        # Do not reject current entry if it is explicitly included.
        next false if included

        # Reject current entry if it is special or a backup file.
        special?(e) || backup?(e)
      end
    end

    def included?(entry)
      glob_include?(site.include, entry) ||
        glob_include?(site.include, File.basename(entry))
    end

    def special?(entry)
      SPECIAL_LEADING_CHAR_REGEX.match?(entry) ||
        SPECIAL_LEADING_CHAR_REGEX.match?(File.basename(entry))
    end

    def backup?(entry)
      entry.end_with?("~")
    end

    def excluded?(entry)
      glob_include?(site.exclude - site.include, relative_to_source(entry)).tap do |excluded|
        if excluded
          Jekyll.logger.debug(
            "EntryFilter:",
            "excluded #{relative_to_source(entry)}"
          )
        end
      end
    end

    # --
    # Check if a file is a symlink.
    # NOTE: This can be converted to allowing even in safe,
    #   since we use Pathutil#in_path? now.
    # --
    def symlink?(entry)
      site.safe && File.symlink?(entry) && symlink_outside_site_source?(entry)
    end

    # --
    # Check if given path is outside of current site's configured source directory.
    # --
    def symlink_outside_site_source?(entry)
      !File.realpath(entry).start_with?(site.in_source_dir)
    end

    # Check if an entry matches a specific pattern.
    # Returns true if path matches against any glob pattern, else false.
    def glob_include?(enumerator, entry)
      entry_with_source = PathManager.join(site.source, entry)
      entry_is_directory = File.directory?(entry_with_source)

      enumerator.any? do |pattern|
        case pattern
        when String
          pattern_with_source = PathManager.join(site.source, pattern)

          File.fnmatch?(pattern_with_source, entry_with_source) ||
            entry_with_source.start_with?(pattern_with_source) ||
            (pattern_with_source == "#{entry_with_source}/" if entry_is_directory)
        when Regexp
          pattern.match?(entry_with_source)
        else
          false
        end
      end
    end
  end
end
