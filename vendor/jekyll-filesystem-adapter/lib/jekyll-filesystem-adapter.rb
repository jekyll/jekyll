require "jekyll/filesystem/adapter/version"

module Jekyll
  class FileSystemAdapter

    def initialize(base_directory, is_safe = true)
      @base_dir = base_directory
      @safe     = is_safe
    end

    def safe?
      @safe || false
    end

    def write(path, content, options = {})
      File.open(path, 'wb') do |f|
        f.write(content)
      end
    end

  end
end
