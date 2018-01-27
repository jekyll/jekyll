# frozen_string_literal: true

module Jekyll
  class ThemeManifestor
    SUB_INDENT = "   ".freeze

    attr_reader :site, :options, :theme

    def initialize(site, options)
      @site = site
      @options = options
      @theme = site.theme
    end

    def manifest
      puts ""
      print_header
      print_body
    end

    # -----------------------------------------------------------------------------------

    private

    def print_header
      print_dashes
      print_clear_line

      print_with_label "Theme Name:", theme.name
      print_with_label "Theme Version:", theme.version
      print_with_label "Theme Directory:", theme.root

      print_dashes
      print_clear_line
    end

    def print_body
      print_label "Gem Contents:"
      print_dir_contents
      print_files_at_root
      print_clear_line
      print_dashes
    end

    # ---------------------------------------------------------------
    # Print helpers
    # ---------------------------------------------------------------

    def print_dir_contents
      theme_directories.each do |d|
        next if d == "."
        print_to_manifest theme_contents, d
      end
    end

    def print_files_at_root
      return if files_at_root.empty?
      print_clear_line
      print_label "  Files at Root:"
      files_at_root.each { |file| print "#{SUB_INDENT} * #{file}" }
    end

    def print_to_manifest(haystack, label)
      print_clear_line
      print_label "  #{label.sub("_", "")}:"

      haystack.each do |n|
        next unless n.start_with? "#{label}/"
        print n.sub("#{label}/", "#{SUB_INDENT} * ")
      end
    end

    def print_label(label)
      print label.upcase
    end

    def print_with_label(label, value)
      print "#{label.upcase.ljust(16)} #{value}"
      print_clear_line
    end

    def print_clear_line
      print " " * spacer_size
    end

    def print_dashes
      dashes = "-" * buffer_size
      puts "#{indent} +#{dashes}+"
    end

    def print(string)
      puts "#{indent} |  #{string.ljust(spacer_size)}  |"
    end

    # ---------------------------------------------------------------
    # Metric helpers
    # ---------------------------------------------------------------

    def buffer_size
      @buffer_size ||= theme.root.length + 21
    end

    def spacer_size
      @spacer_size ||= buffer_size - 4
    end

    def indent
      indent_size = options["indent"] ? options["indent"] - 1 : 3
      " " * indent_size
    end

    # ---------------------------------------------------------------
    # path helpers
    # ---------------------------------------------------------------

    def theme_contents
      files_in(theme.root).map { |f| relative_path(f) }.compact
    end

    def theme_directories
      dirs = theme_contents.map do |f|
        File.dirname(f) unless File.dirname(f).include?("/")
      end
      dirs.uniq!.compact!.sort! do |x, y|
        x.sub("_", "") <=> y.sub("_", "")
      end
    end

    def files_in(dir_path)
      Dir["#{dir_path}/**/*"].reject { |d| File.directory? d }
    end

    def relative_path(file)
      file.sub("#{theme.root}/", "")
    end

    def files_at_root
      theme_contents.reject { |c| c.include? "/" }
    end
  end
end
