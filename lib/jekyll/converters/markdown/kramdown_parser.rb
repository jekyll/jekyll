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
          raise FatalException.new("Missing dependency: kramdown")
        end

        def convert(content)
          # Check for use of coderay
          if @config['kramdown']['use_coderay']
            @config['kramdown'].merge!({
              :coderay_wrap               => @config['kramdown']['coderay']['coderay_wrap'],
              :coderay_line_numbers       => @config['kramdown']['coderay']['coderay_line_numbers'],
              :coderay_line_number_start  => @config['kramdown']['coderay']['coderay_line_number_start'],
              :coderay_tab_width          => @config['kramdown']['coderay']['coderay_tab_width'],
              :coderay_bold_every         => @config['kramdown']['coderay']['coderay_bold_every'],
              :coderay_css                => @config['kramdown']['coderay']['coderay_css']
            })
          end

          Kramdown::Document.new(content, @config["kramdown"].symbolize_keys).to_html
        end

      end
    end
  end
end
