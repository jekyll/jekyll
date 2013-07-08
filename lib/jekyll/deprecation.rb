module Jekyll
  # Represents a deprecations, this need to be the main class for each
  # deprecation, it contains the generic methods for create, manage and
  # process the deprecations
	class Deprecation
    attr_accessor :msg

    attr_reader :key

    # Public: Creates a new Deprecation, in the msg for this deprecation
    # you can use the /:key/ placeholder, which will be replaced by the key of
    # this deprecation
    #
    # properties - the properties for this specific deprecations
    #     :key - the key of this deprecation
    #     :msg - the message of this deprecation
    #
    # Returns the created Deprecation
    def initialize(properties = {})
      @key = properties[:key]
      @msg = properties[:msg]
      if @msg
        @msg.gsub!(":key", @key)
      end
    end

    # Public: process this Deprecation, at this level it will only
    # throw an error, without any verification
    #
    # Returns nothing
    def process
      error
    end

    # Public: log a warning with this deprecation message by the jekyll logger
    #
    # Returns nothing
    def warn
      Jekyll.logger.warn "Deprecation:", msg
    end

    # Public: log an error with this deprecation message by the jekyll logger
    #
    # Returns nothing
    def error
      Jekyll.logger.error "Deprecation:", msg
    end
	end
end