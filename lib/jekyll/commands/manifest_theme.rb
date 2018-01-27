# frozen_string_literal: true

module Jekyll
  class Commands::ManifestTheme < Command
    class << self
      def init_with_program(prog)
        prog.command(:"manifest-theme") do |c|
          c.syntax      "manifest-theme [options]"
          c.description "Create a manifest file at source from your site's theme"

          c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file"
          c.option "indent", "--indent NUM", Integer,
                     "Number of spaces to indent the output. (minimum: 1 | default: 4)"

          c.action do |_, options|
            process(options)
          end
        end
      end

      def process(options = {})
        config = configuration_from_options(options)
        site   = Site.new(config)

        ThemeManifestor.new(site, options).manifest
      end
    end
  end
end
