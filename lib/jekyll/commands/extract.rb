module Jekyll
  module Commands
    class Extract < Command
      class << self
        def init_with_program(prog)
          prog.command(:extract) do |c|
            c.syntax      "extract [DIR (or) FILE-PATH] [options]"
            c.description "Extract files and directories from theme-gem to site"

            c.option "force", "--force", "Force extraction even if file already exists"

            c.action do |args, options|
              process(args, options)
            end
          end
        end

        def process(args, options = {})
          @force = options["force"] if options["force"]
          if args.empty?
            Jekyll.logger.abort_with("Error:",
              "You must specify a theme directory or a file path.")
          else
            config = Jekyll.configuration(options)
            @source = config["source"]
            @theme_dir = Site.new(config).theme.root

            # Substitute leading special-characters in an argument with an
            # 'underscore' to disable extraction of files outside the theme-gem
            # but allow extraction of theme directories with a leading underscore.
            #
            # Process each valid argument individually to enable extraction of
            # multiple files or directories.
            args.map { |i| i.sub(%r!\A\W!, "_") }.each do |arg|
              initiate_extraction arg
            end
          end
        end

        private

        def initiate_extraction(path)
          file_path = Jekyll.sanitized_path(@theme_dir, path)
          if File.exist? file_path
            extract_to_source file_path
          else
            Jekyll.logger.abort_with "Error:", "Specified file or directory doesn't exist"
          end
        end

        def extract_to_source(path)
          if File.directory? path
            dir_path = File.expand_path(path.split("/").last, @source)
            extract_directory dir_path, path
          else
            dir_path = File.dirname(File.join(@source, relative_path(path)))
            extract_file_with_directory dir_path, path
          end
        end

        def extract_directory(dir_path, path)
          if File.exist?(dir_path) && !@force
            already_exists_msg path
          else
            FileUtils.cp_r path, @source
            Dir["#{path}/**/*"].reject { |d| File.directory? d }.each do |file|
              extraction_msg file
            end
          end
        end

        def extract_file_with_directory(dir_path, file_path)
          FileUtils.mkdir_p dir_path unless File.directory? dir_path
          file = file_path.split("/").last
          if File.exist?(File.join(dir_path, file)) && !@force
            already_exists_msg file
          else
            FileUtils.cp_r file_path, dir_path
            extraction_msg file_path
          end
        end

        def relative_path(file)
          file.sub(@theme_dir, "")
        end

        def extraction_msg(file)
          Jekyll.logger.info "Extract:", relative_path(file)
        end

        def already_exists_msg(file)
          Jekyll.logger.warn "Error:", "'#{relative_path(file)}' already exists " \
                             "at destination. Use --force to overwrite."
        end
      end
    end
  end
end
