# frozen_string_literal: true

require "yaml"

module Jekyll
  module TaskUtils
    class RuboCopConfigFormatter
      def initialize(config_file)
        @registry    = Hash.new { |hsh, k| hsh[k] = [] }
        @buffer      = +""
        @config      = sort_hash_by_key(YAML.safe_load_file(config_file))
        @config_file = config_file
      end

      def format!
        inject_banner

        consume :key => "inherit_from"
        consume :key => "require"
        consume :key => "AllCops", :comment => "Directive for all cops" do |key, conf|
          format_all_cops_config(key, conf)
        end
        consume :key => "Jekyll/NoPutsAllowed", :comment => "Configure custom cop"

        stream_builtin_cops
        File.write(@config_file, @buffer.chomp)
      end

      private

      def inject_banner
        @buffer << <<~MSG
          # -----------------------------------------------------------------------------
          # This file has been formatted via a Rake Task configuring cops from
          # RuboCop v#{rubocop_version}.
          #
          # To add more cops, paste configurations at the end of the file and run
          # the rake task via `bundle exec rake rubocop:format_config`.
          # -----------------------------------------------------------------------------

        MSG
      end

      def rubocop_version
        `bundle exec rubocop --version`.chomp
      end

      def consume(key:, comment: nil)
        conf = @config.delete(key)
        @buffer << "# #{comment}\n" if comment

        entry = block_given? ? yield(key, conf) : normalize_entry(key => conf)
        @buffer << entry
        @buffer << "\n"
      end

      def stream_cops_banner
        @buffer << <<~MSG
          # Configure built-in cops
          # =======================

        MSG
      end

      def group_cops_by_department
        @config.each_with_object(@registry) do |(key, conf), registry|
          department = key.split("/", 2)[0]
          registry[department] << { key => conf }
        end
      end

      def stream_builtin_cops
        stream_cops_banner
        group_cops_by_department

        @registry.each do |(dept, cops)|
          @buffer << <<~MSG
            # #{dept} cops
            # #{"-" * 40}
          MSG

          while (entry = cops.shift)
            @buffer << normalize_entry(entry)
          end

          @buffer << "\n"
        end
      end

      def normalize_entry(entry)
        YAML.dump(entry).delete_prefix("---\n")
      end

      def format_all_cops_config(key, conf)
        all_cops_config = %w(TargetRubyVersion Include Exclude).each_with_object({}) do |k, res|
          res[k] = conf.delete(k)
        end
        normalize_entry(key => all_cops_config)
      end

      def sort_hash_by_key(hsh)
        sorted = hsh.sort_by { |key, _v| key }.to_h
        sorted.each_pair.with_object({}) do |(key, value), result|
          new_val = case value
                    when Array
                      value.sort
                    when Hash
                      sort_hash_by_key(value)
                    else
                      value
                    end

          result[key] = new_val
        end
      end
    end
  end
end
