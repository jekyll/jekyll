module Jekyll
  module Deprecations
    # Represents a general command line deprecation
    class Command < Deprecation
      attr_reader :args

      # Public: Create a new Command deprecation
      #
      # properties - the properties for this type of deprecation, all the
      #              parent classes properties will be used to
      #       :args - the command line arguments
      #
      # Returns the created Command deprecation
      def initialize(properties = {})
        super(properties)
        @args = properties[:args]
      end

      # Public: Process the Command deprecation, which by default will throw an
      # error if the arguments of this deprecation have the key of this
      # deprecation
      #
      # Returns nothing
      def process
        if @args.include?(@key)
          super
        end
      end
    end
  end
end