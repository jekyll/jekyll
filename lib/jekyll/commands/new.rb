require 'yaml'
require 'erb'

module Jekyll
  module Commands
    class New < Command
      def self.process(args)
        arg_string = args.join(" ")
        raise ArgumentError, "You must specify a path." if arg_string.empty?
        install_path = File.expand_path(arg_string, Dir.pwd)

        template_site = File.expand_path("../../site_template", File.dirname(__FILE__))
        FileUtils.cp_r template_site, install_path

        process_erb_files(install_path)

        puts "New jekyll site installed in #{install_path}."
      end

      def self.process_erb_files(path)
        erb_files = Dir["#{path}/**/*"].select do |f|
          File.extname(f) == '.erb'
        end

        erb_files.each do |erb_file|
          file_contents = File.read(erb_file)

          File.open(erb_file, 'w') do |file|
            file.write(ERB.new(file_contents).result)
          end

          new_filename = erb_file.chomp '.erb'
          new_filename.gsub! '0000-00-00', Time.now.strftime('%Y-%m-%d')
          FileUtils.mv erb_file, new_filename
        end
      end
    end
  end
end
