module Jekyll
  module Deprecations
    # Represents a default Config deprecation
    class Config < Deprecation
      attr_reader :config

      # Public: Create a new Command deprecation
      #
      # properties - the properties for this type of deprecation, all the
      #              parent classes properties will be used to
      #       :config - the config object for verifications
      #
      # Returns the created Command deprecation
      def initialize(properties = {})
        super(properties)
        @config = properties[:config]
      end

      # Public: Process the Config specific deprecation, which by default was
      # just warn the deprecation message
      #
      # Returns nothing
      def process_config
        warn
      end

      # Public: Process the main Config deprecation, this method calls
      # #process_config if the config of this deprecation has its respective
      # key
      #
      # Returns nothing
      def process
        if @config.has_key?(@key)
          process_config
        end
      end
    end
  end
end