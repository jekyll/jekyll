module Jekyll
  class Deprecator
    def self.process(args)
      no_subcommand(args)
      deprecation_message args, "--server", "The --server command has been replaced by the \
                          'serve' subcommand."
      deprecation_message args, "--no-server", "To build Jekyll without launching a server, \
                          use the 'build' subcommand."
      deprecation_message args, "--auto", "The switch '--auto' has been replaced with '--watch'."
      deprecation_message args, "--no-auto", "To disable auto-replication, simply leave off \
                          the '--watch' switch."
      deprecation_message args, "--pygments", "The 'pygments' setting can only be set in \
                          your config files."
      deprecation_message args, "--paginate", "The 'paginate' setting can only be set in your \
                          config files."
      deprecation_message args, "--url", "The 'url' setting can only be set in your config files."
    end

    def self.no_subcommand(args)
      if args.size > 0 && args.first =~ /^--/ && !%w[--help --version].include?(args.first)
        Jekyll::Stevenson.error "Deprecation:", "Jekyll now uses subcommands instead of just \
                            switches. Run `jekyll help' to find out more."
      end
    end

    def self.deprecation_message(args, deprecated_argument, message)
      if args.include?(deprecated_argument)
        Jekyll::Stevenson.error "Deprecation:", message
      end
    end
  end
end
