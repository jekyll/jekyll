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
          kramdown_configs = if @config['kramdown']['use_coderay']
            base_kramdown_configs.merge({
              :coderay_wrap               => @config['kramdown']['coderay']['coderay_wrap'],
              :coderay_line_numbers       => @config['kramdown']['coderay']['coderay_line_numbers'],
              :coderay_line_number_start  => @config['kramdown']['coderay']['coderay_line_number_start'],
              :coderay_tab_width          => @config['kramdown']['coderay']['coderay_tab_width'],
              :coderay_bold_every         => @config['kramdown']['coderay']['coderay_bold_every'],
              :coderay_css                => @config['kramdown']['coderay']['coderay_css']
            })
          else
            # not using coderay
            base_kramdown_configs
          end
          Kramdown::Document.new(content, @config["kramdown"].symbolize_keys).to_html
        end

        def base_kramdown_configs
          {
            :auto_ids      => @config['kramdown']['auto_ids'],
            :footnote_nr   => @config['kramdown']['footnote_nr'],
            :entity_output => @config['kramdown']['entity_output'],
            :toc_levels    => @config['kramdown']['toc_levels'],
            :smart_quotes  => @config['kramdown']['smart_quotes']
          }
        end
      end
    end
  end
end
