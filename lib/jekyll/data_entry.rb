# frozen_string_literal: true

module Jekyll
  class DataEntry
    attr_accessor :context
    attr_reader :data

    # Create a Jekyll wrapper for given parsed data object.
    #
    #        site - The current Jekyll::Site instance.
    #    abs_path - Absolute path to the data source file.
    # parsed_data - Parsed representation of data source file contents.
    #
    # Returns nothing.
    def initialize(site, abs_path, parsed_data)
      @site = site
      @path = abs_path
      @data = parsed_data
    end

    # Liquid representation of current instance is the parsed data object.
    #
    # Mark as a dependency for regeneration here since every renderable object primarily uses the
    # parsed data object while the parent resource is being rendered by Liquid. Accessing the data
    # object directly via Ruby interface `#[]()` is outside the scope of regeneration.
    #
    # FIXME: Marking as dependency on every call is non-ideal. Optimize at later day.
    #
    # Returns the parsed data object.
    def to_liquid
      add_regenerator_dependencies if incremental_build?
      @data
    end

    # -- Overrides to maintain backwards compatibility --

    # Any missing method will be forwarded to the underlying data object stored in the instance
    # variable `@data`.
    def method_missing(method, *args, &block)
      @data.respond_to?(method) ? @data.send(method, *args, &block) : super
    end

    def respond_to_missing?(method, *)
      @data.respond_to?(method) || super
    end

    def <=>(other)
      data <=> (other.is_a?(self.class) ? other.data : other)
    end

    def ==(other)
      data == (other.is_a?(self.class) ? other.data : other)
    end

    # Explicitly defined to bypass re-routing from `method_missing` hook for greater performance.
    #
    # Returns string representation of parsed data object.
    def inspect
      @data.inspect
    end

    private

    def incremental_build?
      @incremental = @site.config["incremental"] if @incremental.nil?
      @incremental
    end

    def add_regenerator_dependencies
      page = context.registers[:page]
      return unless page&.key?("path")

      absolute_path = \
        if page["collection"]
          @site.in_source_dir(@site.config["collections_dir"], page["path"])
        else
          @site.in_source_dir(page["path"])
        end

      @site.regenerator.add_dependency(absolute_path, @path)
    end
  end
end
