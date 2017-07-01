module Jekyll
  module Deprecator
    extend self

    def process(args)
      arg_is_present? args, "--server", "The --server command has been replaced by the \
                          'serve' subcommand."
      arg_is_present? args, "--serve", "The --server command has been replaced by the \
                          'serve' subcommand."
      arg_is_present? args, "--no-server", "To build Jekyll without launching a server, \
                          use the 'build' subcommand."
      arg_is_present? args, "--auto", "The switch '--auto' has been replaced with \
                          '--watch'."
      arg_is_present? args, "--no-auto", "To disable auto-replication, simply leave off \
                          the '--watch' switch."
      arg_is_present? args, "--pygments", "The 'pygments'settings has been removed in \
                          favour of 'highlighter'."
      arg_is_present? args, "--paginate", "The 'paginate' setting can only be set in \
                          your config files."
      arg_is_present? args, "--url", "The 'url' setting can only be set in your \
                          config files."
      no_subcommand(args)
    end

    def no_subcommand(args)
      unless args.empty? ||
          args.first !~ %r(!/^--/!) || %w(--help --version).include?(args.first)
        deprecation_message "Jekyll now uses subcommands instead of just switches. \
                          Run `jekyll help` to find out more."
        abort
      end
    end

    def arg_is_present?(args, deprecated_argument, message)
      if args.include?(deprecated_argument)
        deprecation_message(message)
      end
    end

    def deprecation_message(message)
      Jekyll.logger.warn "Deprecation:", message
    end

    def defaults_deprecate_type(old, current)
      Jekyll.logger.warn "Defaults:", "The '#{old}' type has become '#{current}'."
      Jekyll.logger.warn "Defaults:", "Please update your front-matter defaults to use \
                        'type: #{current}'."
    end

  end
end
