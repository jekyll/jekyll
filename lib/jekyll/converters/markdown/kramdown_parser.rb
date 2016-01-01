module Jekyll
  module Converters
    class Markdown
      class KramdownParser
        def initialize(config)
          require 'kramdown'
          @config = config
        rescue LoadError
          STDERR.puts 'You are missing a library required for Markdown. Please run:'
          STDERR.puts '  $ [sudo] gem install kramdown'
          raise Errors::FatalException.new("Missing dependency: kramdown")
        end

        def convert(content)
          # Check for use of coderay
          if @config['kramdown']['enable_coderay']
            %w[wrap line_numbers line_numbers_start tab_width bold_every css default_lang].each do |opt|
              key = "coderay_#{opt}"
              @config['kramdown'][key] = @config['kramdown']['coderay'][key] unless @config['kramdown'].key?(key)
            end
          end

          Kramdown::Document.new(content, Utils.symbolize_hash_keys(@config['kramdown'])).to_html
        end

      end
    end
  end
end
