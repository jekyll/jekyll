# frozen_string_literal: true

require "irb"

module Jekyll
  module Commands
    class Console < Command
      class << self
        def init_with_program(prog)
          prog.command(:console) do |c|
            c.syntax "console"
            c.description "Invoke an IRB console with the site loaded"
            c.alias :c

            c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file"

            c.action do |_, options|
              Jekyll::Commands::Console.process(options)
            end
          end
        end

        # TODO: is there a way to add a unit test for this command?
        # rubocop:disable Style/GlobalVars, Metrics/AbcSize, Metrics/MethodLength
        def process(options)
          Jekyll.logger.info "Starting:", "Jekyll v#{Jekyll::VERSION.magenta}" \
                                      " console…"
          Jekyll.logger.info "Environment:", Jekyll.env.cyan
          site = Jekyll::Site.new(configuration_from_options(options))
          site.reset
          site.read
          site.generate

          $JEKYLL_SITE = site
          IRB.setup(nil)
          workspace = IRB::WorkSpace.new
          irb = IRB::Irb.new(workspace)
          IRB.conf[:MAIN_CONTEXT] = irb.context
          eval("site = $JEKYLL_SITE", workspace.binding, __FILE__, __LINE__)
          Jekyll.logger.info "Console:", "Now loaded as " + "site".cyan + " variable."

          trap("SIGINT") do
            irb.signal_handle
          end

          begin
            catch(:IRB_EXIT) do
              irb.eval_input
            end
          end
        end
        # rubocop:enable Style/GlobalVars, Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
