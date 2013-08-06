module Jekyll
  module Deprecations
    class Command
      # Represents the no subcommand deprecations, that need to be thrown when
      # you the user try to call jekyll with an option instead of a subcommand
      # in the first param
      class NoSubcommand < Command
        # Public: Process the NoSubcommand deprecation, that will verify and throw an
        # error if the user gave an option instead of subcommand in first
        # param. If the option was "--help" or "--version" then this method
        # will no throw an error.
        #
        # Returns nothing
        def process
          if @args.size > 0 && @args.first =~ /^--/ && !%w[--help --version].include?(@args.first)
            error
          end
        end
      end
    end
  end
end