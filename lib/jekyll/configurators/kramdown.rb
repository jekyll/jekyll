module Jekyll
  module Configurators
    class Kramdown

      def initialize(config)
        require 'kramdown'
        @config = config
      rescue LoadError
        Jekyll.logger.error 'You are missing a library required for Markdown. Please run:'
        Jekyll.logger.error '  $ [sudo] gem install kramdown'
        raise FatalException.new("Missing dependency: kramdown")
      end

      def tilt_configs
        @tilt_configs ||= base_kramdown_configs.merge(coderay_configs)
      end

      private

      def base_kramdown_configs
        @base_kramdown_configs ||= {
          :auto_ids      => @config['kramdown']['auto_ids'],
          :footnote_nr   => @config['kramdown']['footnote_nr'],
          :entity_output => @config['kramdown']['entity_output'],
          :toc_levels    => @config['kramdown']['toc_levels'],
          :smart_quotes  => @config['kramdown']['smart_quotes']
        }
      end

      def coderay_configs
        @coderay_configs ||= if @config['kramdown']['use_coderay']
          {
            :coderay_wrap               => @config['kramdown']['coderay']['coderay_wrap'],
            :coderay_line_numbers       => @config['kramdown']['coderay']['coderay_line_numbers'],
            :coderay_line_number_start  => @config['kramdown']['coderay']['coderay_line_number_start'],
            :coderay_tab_width          => @config['kramdown']['coderay']['coderay_tab_width'],
            :coderay_bold_every         => @config['kramdown']['coderay']['coderay_bold_every'],
            :coderay_css                => @config['kramdown']['coderay']['coderay_css']
          }
        else
          {}
        end
      end
  end
end
