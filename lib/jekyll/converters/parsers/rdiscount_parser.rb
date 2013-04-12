module Jekyll
  module Converters
    class Markdown
      class RDiscountParser
        def initialize(config)
          require 'rdiscount'
          @config = config
          @rdiscount_extensions = @config['rdiscount']['extensions'].map { |e| e.to_sym }
        rescue LoadError
          STDERR.puts 'You are missing a library required for Markdown. Please run:'
          STDERR.puts '  $ [sudo] gem install rdiscount'
          raise FatalException.new("Missing dependency: rdiscount")
        end
      end
    end
  end
end
