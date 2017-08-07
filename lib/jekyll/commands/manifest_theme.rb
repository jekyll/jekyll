# frozen_string_literal: true

module Jekyll
  class Commands::ManifestTheme < Command
    class << self
      def init_with_program(prog)
        prog.command(:"manifest-theme") do |c|
          c.syntax      "manifest-theme [options]"
          c.description "Create a manifest file at source from your site's theme"

          c.option "console", "--console", "Output manifest contents to terminal"
          c.option "verbose", "--verbose", "Output messages to terminal"
          c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file"

          c.action do |_, options|
            process(options)
          end
        end
      end

      def process(options = {})
        @console = options.delete("console")
        verbose  = options.delete("verbose")
        config   = configuration_from_options(options)

        site     = Site.new(config)
        @theme   = site.theme
        @source  = config["source"]

        manifest_file = site.in_source_dir(".jtheme")
        file_mode = File.exist?(manifest_file) ? "w+" : "a+"

        verbose_output if verbose
        File.open(manifest_file, file_mode) do |file|
          @file = file
          write_theme_manifest
        end
        Jekyll.logger.info "\n", "The manifest has been created at #{manifest_file.cyan}"
      end

      private

      # ---------------------------------------------------------------

      def write_theme_manifest
        print_meta_header

        print_label "\nGem Contents:\n\n"
        print_dir_contents
        print_files_at_root
      end

      # ---------------------------------------------------------------
      # private methods to handle printing to manifest file
      # ---------------------------------------------------------------

      def print_meta_header
        print_dashes

        print_with_label "Theme Name:", @theme.name
        print_with_label "\nTheme Version:", @theme.version
        print_with_label "\nTheme Directory:", @theme.root

        print_dashes
      end

      def print_dir_contents
        theme_directories.each do |d|
          next if d == "."
          print_to_manifest theme_contents, d
        end
      end

      def print_files_at_root
        theme_directories.each do |d|
          next unless d == "."
          print_label "  Files at Root:"
          theme_contents.each do |c|
            print "    * #{c}" unless c.include? "/"
          end
        end
      end

      def print_to_manifest(haystack, label)
        print_label "  #{label.sub("_", "")}:"

        haystack.each do |n|
          next unless n.start_with? "#{label}/"
          print n.sub("#{label}/", "    * ")
        end

        print_clear_line
      end

      def print_label(label)
        print label.upcase
      end

      def print_dashes
        length = @theme.root.length + 4
        print "-" * length
      end

      def print_with_label(label, value)
        print label.upcase
        print "  #{value}"
      end

      def print_clear_line
        print "\n"
      end

      def print(string)
        Jekyll.logger.info "", string.green if @console
        @file.puts string
      end

      # ---------------------------------------------------------------
      # path helper methods
      # ---------------------------------------------------------------

      def files_in(dir_path)
        Dir["#{dir_path}/**/*"].reject { |d| File.directory? d }
      end

      def relative_path(file)
        file.sub("#{@theme.root}/", "")
      end

      def theme_contents
        files_in(@theme.root).map { |f| relative_path(f) }.compact
      end

      def theme_directories
        dirs = theme_contents.map do |f|
          File.dirname(f) unless File.dirname(f).include?("/")
        end

        dirs.uniq!.compact!.sort! do |x, y|
          x.sub("_", "") <=> y.sub("_", "")
        end
      end

      # ---------------------------------------------------------------

      def verbose_output
        Jekyll.logger.info "Source:", @source
        Jekyll.logger.info "Theme Dir.:", @theme.root
        Jekyll.logger.info "Theme Name:", @theme.name
        Jekyll.logger.info "Theme Version:", @theme.version
      end
    end
  end
end
