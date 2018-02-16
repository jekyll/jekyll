# frozen_string_literal: true

module Jekyll
  module External
    class << self
      #
      # Gems that, if installed, should be loaded.
      # Usually contain subcommands.
      #
      def blessed_gems
        %w(
          jekyll-docs
          jekyll-import
        )
      end

      #
      # Require a gem or file if it's present, otherwise silently fail.
      #
      # names - a string gem name or array of gem names
      #
      def require_if_present(names)
        Array(names).each do |name|
          begin
            require name
          rescue LoadError
            Jekyll.logger.debug "Couldn't load #{name}. Skipping."
            yield(name, version_constraint(name)) if block_given?
            false
          end
        end
      end

      #
      # The version constraint required to activate a given gem.
      # Usually the gem version requirement is "> 0," because any version
      # will do. In the case of jekyll-docs, however, we require the exact
      # same version as Jekyll.
      #
      # Returns a String version constraint in a parseable form for
      # RubyGems.
      def version_constraint(gem_name)
        return "= #{Jekyll::VERSION}" if gem_name.to_s.eql?("jekyll-docs")
        "> 0"
      end

      #
      # Require a gem or gems. If it's not present, show a very nice error
      # message that explains everything and is much more helpful than the
      # normal LoadError.
      #
      # names - a string gem name or array of gem names
      #
      def require_with_graceful_fail(names)
        Array(names).each do |name|
          begin
            Jekyll.logger.debug "Requiring:", name.to_s
            require name
          rescue LoadError => e
            Jekyll.logger.error "Dependency Error:", <<-MSG
Yikes! It looks like you don't have #{name} or one of its dependencies installed.
In order to use Jekyll as currently configured, you'll need to install this gem.

The full error message from Ruby is: '#{e.message}'

If you run into trouble, you can find helpful resources at https://jekyllrb.com/help/!
            MSG
            raise Jekyll::Errors::MissingDependencyException, name
          end
        end
      end
    end
  end
end
