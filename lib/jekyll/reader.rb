# encoding: UTF-8
require 'csv'

module Jekyll
  class Reader
    # Public: Initialize a new Reader.

    # @return [Object]
    def initialize(source, dest)
      @source = source
      @dest = dest
    end

    # Public: Prefix a given path with the source directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         source directory
    #
    # Returns a path which is prefixed with the source directory.
    def in_source_dir(*paths)
      paths.reduce(@source) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: Prefix a given path with the destination directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         destination directory
    #
    # Returns a path which is prefixed with the destination directory.
    def in_dest_dir(*paths)
      paths.reduce(@dest) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end
  end
end