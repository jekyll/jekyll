# frozen_string_literal: true

require "erb"

class Jekyll::Commands::NewTheme < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:"new-theme") do |c|
        c.syntax "new-theme NAME"
        c.description "Creates a new Jekyll theme scaffold"
        c.option "code_of_conduct", \
          "-c", "--code-of-conduct", \
          "Include a Code of Conduct. (defaults to false)"

        c.action do |args, opts|
          Jekyll::Commands::NewTheme.process(args, opts)
        end
      end
    end

    # rubocop:disable Metrics/AbcSize
    def process(args, opts)
      if !args || args.empty?
        raise Jekyll::Errors::InvalidThemeName, "You must specify a theme name."
      end

      new_theme_name = args.join("_")
      theme = Jekyll::ThemeBuilder.new(new_theme_name, opts)
      if theme.path.exist?
        Jekyll.logger.abort_with "Conflict:", "#{theme.path} already exists."
      end

      theme.create!
      Jekyll.logger.info "Your new Jekyll theme, #{theme.name.cyan}," \
        " is ready for you in #{theme.path.to_s.cyan}!"
      Jekyll.logger.info "For help getting started, read #{theme.path}/README.md."
    end
    # rubocop:enable Metrics/AbcSize
  end
end
