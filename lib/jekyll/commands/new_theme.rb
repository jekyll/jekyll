require 'erb'

module Jekyll
  module Commands
    class NewTheme < Command
      class << self
        def init_with_program(prog)
          prog.command(:"new-theme") do |c|
            c.syntax 'new-theme NAME'
            c.description 'Creates a new Jekyll theme scaffold'

            c.action do |args, _|
              Jekyll::Commands::NewTheme.process(args)
            end
          end
        end

        def process(args)
          raise InvalidThemeName, 'You must specify a theme name.' if args.empty?

          new_theme_name = args.join("_")
          theme = ThemeBuilder.new(new_theme_name)
          if theme.path.exist?
            Jekyll.logger.abort_with "Conflict:", "#{theme.path} already exists."
          end

          theme.create!
          Jekyll.logger.info "Your new Jekyll theme, #{theme.name} is ready for you in #{theme.path}."
        end

        class ThemeBuilder
          attr_reader :name, :path
          def initialize(theme_name)
            @name = theme_name
            @path = Pathname.new(File.expand_path(theme_name, Dir.pwd))
          end

          def create!
            create_directories
            create_gemspec
            create_readme
          end

          private

          def create_directories
            Dir.chdir(path) do
              FileUtils.mkdir_p(%w{_includes _layouts _sass})
            end
          end
        end

        private

        def gemfile_contents
          <<-RUBY
source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "#{Jekyll::VERSION}"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
# group :jekyll_plugins do
#   gem "jekyll-github-metadata", "~> 1.0"
# end
RUBY
        end
      end
    end
  end
end
