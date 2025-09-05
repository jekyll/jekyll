# frozen_string_literal: true

module Jekyll
  module Commands
    class Doctor < Command
      class << self
        def init_with_program(prog)
          prog.command(:doctor) do |c|
            c.syntax "doctor"
            c.description "Search site and print specific deprecation warnings"
            c.alias(:hyde)

            c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file"

            c.action do |_, options|
              Jekyll::Commands::Doctor.process(options)
            end
          end
        end

        def process(options)
          site = Jekyll::Site.new(configuration_from_options(options))
          site.reset
          site.read
          site.generate

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
            !conflicting_urls(site),
            !urls_only_differ_by_case(site),
            proper_site_url?(site),
            properly_gathered_posts?(site),
          ].all?
        end

        def properly_gathered_posts?(site)
          return true if site.config["collections_dir"].empty?

          posts_at_root = site.in_source_dir("_posts")
          return true unless File.directory?(posts_at_root)

          Jekyll.logger.warn "Warning:",
                             "Detected '_posts' directory outside custom `collections_dir`!"
          Jekyll.logger.warn "",
                             "Please move '#{posts_at_root}' into the custom directory at " \
                             "'#{site.in_source_dir(site.config["collections_dir"])}'"
          false
        end

        def deprecated_relative_permalinks(site)
          if site.config["relative_permalinks"]
            Jekyll::Deprecator.deprecation_message "Your site still uses relative permalinks, " \
                                                   "which was removed in Jekyll v3.0.0."
            true
          end
        end

        def conflicting_urls(site)
          conflicting_urls = false
          destination_map(site).each do |dest, paths|
            next unless paths.size > 1

            conflicting_urls = true
            Jekyll.logger.warn "Conflict:",
                               "The following destination is shared by multiple files."
            Jekyll.logger.warn "", "The written file may end up with unexpected contents."
            Jekyll.logger.warn "", dest.to_s.cyan
            paths.each { |path| Jekyll.logger.warn "", " - #{path}" }
            Jekyll.logger.warn ""
          end
          conflicting_urls
        end

        def fsnotify_buggy?(_site)
          return true unless Utils::Platforms.osx?

          if Dir.pwd != `pwd`.strip
            Jekyll.logger.error <<~STR
              We have detected that there might be trouble using fsevent on your
              operating system, you can read https://github.com/thibaudgg/rb-fsevent/wiki/no-fsevents-fired-(OSX-bug)
              for possible workarounds or you can work around it immediately
              with `--force-polling`.
            STR

            false
          end

          true
        end

        def urls_only_differ_by_case(site)
          urls_only_differ_by_case = false
          urls = case_insensitive_urls(site.pages + site.docs_to_write, site.dest)
          urls.each_value do |real_urls|
            next unless real_urls.uniq.size > 1

            urls_only_differ_by_case = true
            Jekyll.logger.warn "Warning:", "The following URLs only differ by case. On a " \
                                           "case-insensitive file system one of the URLs will be " \
                                           "overwritten by the other: #{real_urls.join(", ")}"
          end
          urls_only_differ_by_case
        end

        def proper_site_url?(site)
          url = site.config["url"]
          [
            url_exists?(url),
            url_valid?(url),
            url_absolute(url),
          ].all?
        end

        private

        def destination_map(site)
          {}.tap do |result|
            site.each_site_file do |thing|
              next if allow_used_permalink?(thing)

              dest_path = thing.destination(site.dest)
              ((result[dest_path] ||= []) << thing.path).uniq!
            end
          end
        end

        def allow_used_permalink?(item)
          defined?(JekyllRedirectFrom) && item.is_a?(JekyllRedirectFrom::RedirectPage)
        end

        def case_insensitive_urls(things, destination)
          things.each_with_object({}) do |thing, memo|
            dest = thing.destination(destination)
            (memo[dest.downcase] ||= []) << dest
          end
        end

        def url_exists?(url)
          return true unless url.nil? || url.empty?

          Jekyll.logger.warn "Warning:", "You didn't set an URL in the config file, you may " \
                                         "encounter problems with some plugins."
          false
        end

        def url_valid?(url)
          Addressable::URI.parse(url)
          true
        # Addressable::URI#parse only raises a TypeError
        # https://github.com/sporkmonger/addressable/blob/0a0e96acb17225f9b1c9cab0bad332b448934c9a/lib/addressable/uri.rb#L103
        rescue TypeError
          Jekyll.logger.warn "Warning:", "The site URL does not seem to be valid, " \
                                         "check the value of `url` in your config file."
          false
        end

        def url_absolute(url)
          return true if url.is_a?(String) && Addressable::URI.parse(url).absolute?

          Jekyll.logger.warn "Warning:", "Your site URL does not seem to be absolute, " \
                                         "check the value of `url` in your config file."
          false
        end
      end
    end
  end
end
