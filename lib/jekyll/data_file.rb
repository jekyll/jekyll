# frozen_string_literal: true

module Jekyll
  class DataFile
    attr_accessor :context
    attr_reader :data

    def initialize(site, abs_path, data)
      @site = site
      @path = abs_path
      @data = data
    end

    def to_liquid
      add_regenerator_dependencies if incremental_build?
      @data
    end

    # Overrides to maintain backwards compatibility.

    # Any missing method will be forwarded to the underlying data object stored in
    #   the instance variable `@data`.
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
