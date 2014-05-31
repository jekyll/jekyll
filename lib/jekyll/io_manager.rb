module Jekyll
  module IOManager

    # Public: Whether or not the current class is in safe mode.
    #  Including class should override this.
    #
    # Returns true if the site is in safe mode, false otherwise.
    def safe?
      false
    end

    def read_options
      if instance_variable_defined?("@file_read_opts")
        instance_variable_get("@file_read_opts")
      elsif instance_variable_defined?("@site") && instance_variable_get("@site").instance_variable_defined?("@file_read_opts")
        instance_variable_get("@site").instance_variable_get("@file_read_opts")
      else
        {}
      end
    end

    def file_contents(path, readoptions = {})
      options = read_options.merge(readoptions)
      if options.fetch(:bytes, 0) > 0
        File.open(realpath(path), 'rb') { |f| f.read(options[:bytes]) }
      else
        File.read(realpath(path))
      end
    end

    def realpath(path)
      File.realpath(path)
    end

    def sanitized_path(base_directory, questionable_path)
      clean_path = File.expand_path(questionable_path, "/")
      clean_path.gsub!(/\A\w\:\//, '/')
      unless clean_path.start_with?(base_directory)
        File.join(base_directory, clean_path)
      else
        clean_path
      end
    end

    def dir_entries(path)
      real_path = realpath(path)
      Dir.entries(real_path).map { |f| sanitized_path(real_path, f) }.select { |f| !file_allowed?(f) }
    end

    def directory?(path)
      real_path = realpath(path)
      File.directory?(real_path) && file_allowed?(real_path)
    end

    def file_allowed?(path)
      !safe? || !File.symlink?(realpath(path))
    end

    def file_exist?(path)
      File.exist?(path) && file_allowed?(path)
    end

    def sanitize_filename(name)
      name.gsub(/[^\w\s_-]+/, '')
          .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
          .gsub(/\s+/, '_')
    end

    extend Jekyll::IOManager
  end
end
