# frozen_string_literal: true

module Jekyll
  module Commands
    class Build
      class Footprint
        class << self
          def check(options)
            @source ||= File.expand_path options["source"]
            setup_registry
            return if registry.empty?

            Jekyll.logger.warn "Warning:", "This source is already being served:"
            Jekyll.logger.warn ""
            registry.each_pair { |id, opts| log_warnings(id, opts) }
          end

          def register(server, options = {})
            @source ||= File.expand_path options["source"]
            id = server.__id__
            path = footprint_file(id)

            setup_footprint_directory

            registry[id] = options
            File.open(path, "wb") do |file|
              file.puts(JSON.generate(options))
            end
          end

          def erase(server)
            id = server.__id__
            path = footprint_file(id)
            return unless registry.key?(id) && File.exist?(path)

            FileUtils.remove_file(path, :force => true)
          end

          private

          attr_reader :source, :registry

          def setup_registry
            @registry = Dir.glob("#{footprint_directory}/*.json").map! do |entry|
              [File.basename(entry, ".*"), JSON.parse(File.read(entry))]
            end.to_h
          end

          LOG_KEYS = %w(url baseurl destination).freeze
          private_constant :LOG_KEYS

          def log_warnings(id, opts)
            Jekyll.logger.warn "SERVER_ID:", id.to_s.cyan
            LOG_KEYS.each { |key| Jekyll.logger.warn(key.upcase) { opts[key].inspect.cyan } }
            Jekyll.logger.warn "JEKYLL_ENV:", Jekyll.env.cyan
            Jekyll.logger.warn ""
          end

          def footprint_directory
            Jekyll.sanitized_path(source, ".jekyll-footprint")
          end

          def setup_footprint_directory
            return if File.directory?(footprint_directory)

            FileUtils.mkdir_p(footprint_directory)
            File.open(in_footprint_dir(".gitignore"), "wb") { |f| f.puts "*" }
          end

          def in_footprint_dir(*paths)
            paths.reduce(footprint_directory) do |base, path|
              Jekyll.sanitized_path(base, path)
            end
          end

          def footprint_file(id)
            in_footprint_dir("#{id}.json")
          end
        end
      end
    end
  end
end
