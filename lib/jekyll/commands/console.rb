# frozen_string_literal: true

module Jekyll
  module ConsoleMethods
    def site
      Jekyll.sites.first
    end
  end
  private_constant :ConsoleMethods

  module Commands
    class Console < Command
      CONSOLE_DEPS = [
        "irb",
        "irb/ext/save-history",
        "irb/completion",
      ].freeze
      BUILD_METHODS = %w(process reset read generate render cleanup write).freeze
      COLORED_BUILD_METHOD_NAMES = BUILD_METHODS.map(&:cyan).join(", ")
      TIMED_BUILD_METHOD_NAMES = BUILD_METHODS.first(2).map! { |ph| "timed_#{ph}".cyan }.join(", ")
      private_constant :CONSOLE_DEPS, :BUILD_METHODS, :COLORED_BUILD_METHOD_NAMES,
                       :TIMED_BUILD_METHOD_NAMES

      class << self
        # rubocop:disable Metrics/MethodLength
        def init_with_program(prog)
          prog.command(:console) do |c|
            c.syntax "console"
            c.description <<~DESC.rstrip
              Start an interactive console preloaded with a site instance.

                  The site instance can be accessed in the console by invoking #{"site".cyan}.

                  This instance responds to additional (console-only) methods that allows
                  one to instrument the instance for more information. The build methods
                  #{COLORED_BUILD_METHOD_NAMES} have a `timed_`
                  equivalent namely #{TIMED_BUILD_METHOD_NAMES}, etc that output the
                  time taken to run the build method.

                  In additon, the instance also responds to the following console-only methods:
                    - pre_render  : Outputs time taken to run phases #{"reset".cyan} > #{"read".cyan} > #{"generate".cyan}.
                    - post_render : Outputs time taken to run phases #{"cleanup".cyan} > #{"write".cyan}.

                  Invoke #{"exit".yellow} or press #{"Ctrl+D".yellow} to exit console.
            DESC
            c.alias(:c)

            c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file(s)"
            c.option "blank", "--blank", "Preload a bare site"
            c.option "processed", "--processed", "Preload with a fully built site"

            c.action do |_, options|
              process(options)
            end
          end
        end
        # rubocop:enable Metrics/MethodLength

        def process(options)
          ENV["JEKYLL_ENV"] ||= "console"

          require_relative "console/site"
          Jekyll::ConsoleSite.new(Jekyll.configuration(options)).tap do |site|
            log_messages(site)
            process_site(site, options)
          end

          start_console
        end

        private

        def log_messages(site)
          log "Source:", site.source
          log "Destination:", site.dest
          log "Console:", "Bare site initialized."
          log "", "ProTips:"
          log "", "* Access the site instance by invoking #{"site".cyan} in the console."
          log "", "* Invoke #{"exit".yellow} or press #{"Ctrl+D".yellow} to exit console."
        end

        def start_console
          print "\nInitializing console "

          60.times do
            print "."
            sleep 0.03
          end
          log "\n\n"

          CONSOLE_DEPS.each { |dep| require dep }
          IRB::ExtendCommandBundle.include ConsoleMethods
          IRB.start
        end

        def process_site(site, options)
          return if options["blank"]

          if options["processed"]
            site.timed_process
          else
            site.timed_read
            site.timed_generate
            site.timed_cleanup
          end
        end

        def log(topic = "", message = "")
          Jekyll.logger.info topic, message
        end
      end
    end
  end
end
