# encoding: UTF-8
require "jekyll-filesystem-adapter/version"
require 'fileutils'

module Jekyll
  class FileSystemAdapter

    class << self

      def sanitized_path(base_directory, questionable_path)
        clean_path = File.expand_path(questionable_path, "/")
        clean_path.gsub!(/\A\w\:\//, '/')

        unless clean_path.start_with?(base_directory)
          File.join(base_directory, clean_path)
        else
          clean_path
        end
      end

    end

    attr_reader :base_dir, :safe, :site

    def initialize(base_directory, options = {})
      @base_dir = base_directory
      @safe     = options.fetch(:safe, false)
      @site     = options.fetch(:site, nil)
    end

    def safe?
      @safe || false
    end

    def sanitized_path(*paths)
      case paths.size
      when 2
        self.class.sanitized_path(*paths)
      when 1
        self.class.sanitized_path(base_dir, paths.pop)
      else
        raise ArgumentError.new("FileSystemAdapter#sanitized_path takes 1 or 2 arguments.")
      end
    end

    def realpath(questionable_path)
      File.realpath(questionable_path)
    end

    #
    # Asking Questions
    #

    def symlink?(path_to_check)
      File.symlink?(path_to_check)
    end

    def file?(path_to_check)
      File.file?(path_to_check)
    end

    def directory?(path_to_check)
      File.directory?(path_to_check)
    end

    def exist?(path_to_check)
      full_path = sanitized_path(path_to_check)
      File.exist?(full_path)
    end

    def file_allowed?(path_to_check)
      full_path = sanitized_path(path_to_check)
      !safe? || !symlink?(full_path)
    end

    #
    # Directory Actions
    #

    def chdir(directory_to_go_to, &block)
      Dir.chdir(directory_to_go_to, &block)
    end

    def glob(path_to_glob, flags = nil)
      if flags.nil?
        Dir.glob(path_to_glob)
      else
        Dir.glob(path_to_glob, flags)
      end
    end

    def dir_entries(directory)
      glob sanitized_path(directory, File.join('**', '*'))
    end

    def rm_rf(file_or_files)
      files = Array(file_or_files).select { |path| exist?(path) }
      FileUtils.rm_rf(files)
    end

    def mkdir_p(directory)
      FileUtils.mkdir_p(directory) unless exist?(directory)
    end

    #
    # File Actions
    #

    def read(path, options = {})
      File.open(path, 'rb') do |f|
        if options[:bytes].nil?
          f.read
        else
          f.read options[:bytes]
        end
      end
    end

    def write(path, content, options = {})
      File.open(path, 'wb') do |f|
        f.write(content)
      end
    end

    def sanitize_filename(name)
      name.gsub(/[^\w\s_-]+/, '')
          .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
          .gsub(/\s+/, '_')
    end

    def mtime(path)
      File.mtime sanitized_path(path)
    end

    def basename(path, suffix = '')
      File.basename(path, suffix)
    end

    def dirname(path)
      File.dirname(path)
    end

  end
end
