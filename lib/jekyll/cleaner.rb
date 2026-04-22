# frozen_string_literal: true

module Jekyll
  # Handles the cleanup of a site's destination before it is built.
  class Cleaner
    HIDDEN_FILE_REGEX = %r!/\.{1,2}$!.freeze
    attr_reader :site

    def initialize(site)
      @site = site
    end

    # Cleans up the site's destination directory
    def cleanup!
      FileUtils.rm_rf(obsolete_files)
      FileUtils.rm_rf(metadata_file) unless @site.incremental?
    end

    private

    # Private: The list of files and directories to be deleted during cleanup process
    #
    # Returns an Array of the file and directory paths
    def obsolete_files
      out = (existing_files - new_files - new_dirs + replaced_files).to_a
      Jekyll::Hooks.trigger :clean, :on_obsolete, out
      out
    end

    # Private: The metadata file storing dependency tree and build history
    #
    # Returns an Array with the metadata file as the only item
    def metadata_file
      [site.regenerator.metadata_file]
    end

    # Private: The list of existing files, apart from those included in
    # keep_files and hidden files.
    #
    # Returns a Set with the file paths
    def existing_files
      files = Set.new
      dirs = keep_dirs

      Utils.safe_glob(site.in_dest_dir, ["**", "*"], File::FNM_DOTMATCH).each do |file|
        next if HIDDEN_FILE_REGEX.match?(file) || keep_file?(file) || dirs.include?(file)

        files << file
      end

      files
    end

    # Private: The list of files to be created when site is built.
    #
    # Returns a Set with the file paths
    def new_files
      @new_files ||= Set.new.tap do |files|
        site.each_site_file { |item| files << item.destination(site.dest) }
      end
    end

    # Private: The list of directories to be created when site is built.
    # These are the parent directories of the files in #new_files.
    #
    # Returns a Set with the directory paths
    def new_dirs
      @new_dirs ||= new_files.flat_map { |file| parent_dirs(file) }.to_set
    end

    # Private: The list of parent directories of a given file
    #
    # Returns an Array with the directory paths
    def parent_dirs(file)
      parent_dir = File.dirname(file)
      if parent_dir == site.dest
        []
      else
        parent_dirs(parent_dir).unshift(parent_dir)
      end
    end

    # Private: The list of existing files that will be replaced by a directory
    # during build
    #
    # Returns a Set with the file paths
    def replaced_files
      new_dirs.select { |dir| File.file?(dir) }.to_set
    end

    # Private: The list of directories that need to be kept because they are
    # parent directories of files specified in keep_files
    #
    # Returns a Set with the directory paths
    def keep_dirs
      site.keep_files.flat_map do |pattern|
        paths = Utils.safe_glob(site.dest, [pattern], File::FNM_DOTMATCH)
        paths = [site.in_dest_dir(pattern)] if paths.empty?
        paths.flat_map { |path| parent_dirs(path) }
      end.to_set
    end

    # Private: Returns true if the given file matches any pattern in keep_files.
    # Supports glob patterns (*, **, ?, [...]), and also preserves all files
    # under a matched directory path.
    #
    # Returns a Boolean
    def keep_file?(file)
      relative = file.delete_prefix("#{site.dest}/")
      site.keep_files.any? do |pattern|
        File.fnmatch?(pattern, relative, File::FNM_PATHNAME | File::FNM_DOTMATCH) ||
          relative.start_with?("#{pattern}/")
      end
    end
  end
end
