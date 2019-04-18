# frozen_string_literal: true

module Jekyll
  class EntryFilter
    attr_reader :site
    SPECIAL_LEADING_CHARACTERS = [
      ".", "_", "#", "~",
    ].freeze

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
        # Reject this entry if it is a symlink.
        next true if symlink?(e)
        # Do not reject this entry if it is included.
        next false if included?(e)

        # Reject this entry if it is special, a backup file, or excluded.
        special?(e) || backup?(e) || excluded?(e)
      end
    end

    def included?(entry)
      glob_include?(site.include, entry) ||
        glob_include?(site.include, File.basename(entry))
    end

    def special?(entry)
      SPECIAL_LEADING_CHARACTERS.include?(entry[0..0]) ||
        SPECIAL_LEADING_CHARACTERS.include?(File.basename(entry)[0..0])
    end

    def backup?(entry)
      entry[-1..-1] == "~"
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
    # NOTE: Pathutil#in_path? gets the realpath.
    # @param [<Anything>] entry the entry you want to validate.
    # Check if a path is outside of our given root.
    # --
    def symlink_outside_site_source?(entry)
      !Pathutil.new(entry).in_path?(
        site.in_source_dir
      )
    end

    # --
    # Check if an entry matches a specific pattern and return true,false.
    # Returns true if path matches against any glob pattern.
    # --
    def glob_include?(enum, entry)
      entry_path = Pathutil.new(site.in_source_dir).join(entry)
      enum.any? do |exp|
        # Users who send a Regexp knows what they want to
        # exclude, so let them send a Regexp to exclude files,
        # we will not bother caring if it works or not, it's
        # on them at this point.

        if exp.is_a?(Regexp)
          entry_path =~ exp

        else
          item = Pathutil.new(site.in_source_dir).join(exp)

          # If it's a directory they want to exclude, AKA
          # ends with a "/" then we will go on to check and
          # see if the entry falls within that path and
          # exclude it if that's the case.

          if entry.end_with?("/")
            entry_path.in_path?(
              item
            )

          else
            File.fnmatch?(item, entry_path) ||
              entry_path.to_path.start_with?(
                item
              )
          end
        end
      end
    end
  end
end
