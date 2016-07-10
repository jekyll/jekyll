require "erb"

class Jekyll::Commands::NewTheme < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:"new-theme") do |c|
        c.syntax "new-theme NAME"
        c.description "Creates a new Jekyll theme scaffold"

        c.action do |args, _|
          Jekyll::Commands::NewTheme.process(args)
        end
      end
    end

    def process(args)
      if !args || args.empty?
        raise Jekyll::Errors::InvalidThemeName, "You must specify a theme name."
      end

      new_theme_name = args.join("_")
      theme = Jekyll::ThemeBuilder.new(new_theme_name)
      if theme.path.exist?
        Jekyll.logger.abort_with "Conflict:", "#{theme.path} already exists."
      end

      theme.create!
      Jekyll.logger.info "Your new Jekyll theme, #{theme.name}," \
        " is ready for you in #{theme.path}!"
      Jekyll.logger.info "For help getting started, read #{theme.path}/README.md."
    end
  end
end
