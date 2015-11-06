module Jekyll
  module Commands
    class Doctor < Command
      class << self

        def init_with_program(prog)
          prog.command(:doctor) do |c|
            c.syntax 'doctor'
            c.description 'Search site and print specific deprecation warnings'
            c.alias(:hyde)

            c.option '--config CONFIG_FILE[,CONFIG_FILE2,...]', Array, 'Custom configuration file'

            c.action do |args, options|
              Jekyll::Commands::Doctor.process(options)
            end
          end
        end

        def process(options)
          site = Jekyll::Site.new(configuration_from_options(options))
          site.read

          if healthy?(site)
            Jekyll.logger.info "Your test results", "are in. Everything looks fine."
          else
            abort
          end
        end

        def healthy?(site)
          [
            fsnotify_buggy?(site),
            !deprecated_relative_permalinks(site),
            !conflicting_urls(site)
          ].all?
        end

        def deprecated_relative_permalinks(site)
          if site.config['relative_permalinks']
            Jekyll::Deprecator.deprecation_message "Your site still uses relative" +
                                " permalinks, which was removed in" +
                                " Jekyll v3.0.0."
            return true
          end
        end

        def conflicting_urls(site)
          conflicting_urls = false
          urls = {}
          urls = collect_urls(urls, site.pages, site.dest)
          urls = collect_urls(urls, site.posts.docs, site.dest)
          urls.each do |url, paths|
            if paths.size > 1
              conflicting_urls = true
              Jekyll.logger.warn "Conflict:", "The URL '#{url}' is the destination" +
                " for the following pages: #{paths.join(", ")}"
            end
          end
          conflicting_urls
        end

        def fsnotify_buggy?(site)
          return true if !Utils::Platforms.osx?
          if Dir.pwd != `pwd`.strip
            Jekyll.logger.error "  " + <<-STR.strip.gsub(/\n\s+/, "\n  ")
              We have detected that there might be trouble using fsevent on your
              operating system, you can read https://github.com/thibaudgg/rb-fsevent/wiki/no-fsevents-fired-(OSX-bug)
              for possible work arounds or you can work around it immediately
              with `--force-polling`.
            STR

            false
          end

          true
        end

        private
        def collect_urls(urls, things, destination)
          things.each do |thing|
            dest = thing.destination(destination)
            if urls[dest]
              urls[dest] << thing.path
            else
              urls[dest] = [thing.path]
            end
          end
          urls
        end

      end

    end
  end
end
