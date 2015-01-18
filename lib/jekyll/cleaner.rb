require 'set'

module Jekyll
  class Site
    # Handles the cleanup of a site's destination before it is built.
    class Cleaner
      attr_reader :site

      def initialize(site)
        @site = site
      end

      # Cleans up the site's destination directory
      def cleanup!
        FileUtils.rm_rf(obsolete_files)
        FileUtils.rm_rf(metadata_file) if @site.full_rebuild?
      end

      private

      # Private: The list of files and directories to be deleted during cleanup process
      #
      # Returns an Array of the file and directory paths
      def obsolete_files
        (existing_files - new_files - new_dirs + replaced_files).to_a
      end

      # Private: The metadata file storing dependency tree and build history
      #
      # Returns an Array with the metdata file as the only item
      def metadata_file
        [site.regenerator.metadata_file]
      end

      # Private: The list of existing files, apart from those included in keep_files and hidden files.
      #
      # Returns a Set with the file paths
      def existing_files
        files = Set.new
        Dir.glob(site.in_dest_dir("**", "*"), File::FNM_DOTMATCH) do |file|
          files << file unless file =~ /\/\.{1,2}$/ || file =~ keep_file_regex || keep_dirs.include?(file)
        end
        files
      end

      # Private: The list of files to be created when site is built.
      #
      # Returns a Set with the file paths
      def new_files
        files = Set.new
        site.each_site_file { |item| files << item.destination(site.dest) }
        files
      end

      # Private: The list of directories to be created when site is built.
      # These are the parent directories of the files in #new_files.
      #
      # Returns a Set with the directory paths
      def new_dirs
        new_files.map { |file| parent_dirs(file) }.flatten.to_set
      end

      # Private: The list of parent directories of a given file
      #
      # Returns an Array with the directory paths
      def parent_dirs(file)
        parent_dir = File.dirname(file)
        if parent_dir == site.dest
          []
        else
          [parent_dir] + parent_dirs(parent_dir)
        end
      end

      # Private: The list of existing files that will be replaced by a directory during build
      #
      # Returns a Set with the file paths
      def replaced_files
        new_dirs.select { |dir| File.file?(dir) }.to_set
      end

      # Private: The list of directories that need to be kept because they are parent directories
      # of files specified in keep_files
      #
      # Returns a Set with the directory paths
      def keep_dirs
        site.keep_files.map { |file| parent_dirs(site.in_dest_dir(file)) }.flatten.to_set
      end

      # Private: Creates a regular expression from the config's keep_files array
      #
      # Examples
      #   ['.git','.svn'] creates the following regex: /\/(\.git|\/.svn)/
      #
      # Returns the regular expression
      def keep_file_regex
        or_list = site.keep_files.join("|")
        pattern = "\/(#{or_list.gsub(".", "\.")})"
        Regexp.new pattern
      end
    end
  end
end
