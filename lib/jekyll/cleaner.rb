require 'set'

module Jekyll
  class Site
    # Handles the cleanup of a site's destination before it is built.
    class Cleaner
      def initialize(site)
        @site = site
      end

      # Cleans up the site's destination directory
      def cleanup!
        FileUtils.rm_rf(obsolete_files)
      end

      private

      # Private: The list of files and directories to be deleted during cleanup process
      #
      # Returns an Array of the file and directory paths
      def obsolete_files
        (existing_files - new_files - new_dirs + replaced_files).to_a
      end

      # Private: The list of existing files, apart from those included in keep_files and hidden files.
      #
      # Returns a Set with the file paths
      def existing_files
        files = Set.new
        Dir.glob(File.join(@site.dest, "**", "*"), File::FNM_DOTMATCH) do |file|
          files << file unless file =~ /\/\.{1,2}$/ || file =~ keep_file_regex
        end
        files
      end

      # Private: The list of files to be created when site is built.
      #
      # Returns a Set with the file paths
      def new_files
        files = Set.new
        @site.each_site_file { |item| files << item.destination(@site.dest) }
        files
      end

      # Private: The list of directories to be created when site is built.
      # These are the parent directories of the files in #new_files.
      #
      # Returns a Set with the directory paths
      def new_dirs
        new_files.map { |file| File.dirname(file) }.to_set
      end

      # Private: The list of existing files that will be replaced by a directory during build
      #
      # Returns a Set with the file paths
      def replaced_files
        new_dirs.select { |dir| File.file?(dir) }.to_set
      end

      # Private: Creates a regular expression from the config's keep_files array
      #
      # Examples
      #   ['.git','.svn'] creates the following regex: /\/(\.git|\/.svn)/
      #
      # Returns the regular expression
      def keep_file_regex
        or_list = @site.keep_files.join("|")
        pattern = "\/(#{or_list.gsub(".", "\.")})"
        Regexp.new pattern
      end
    end
  end
end
