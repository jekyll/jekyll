# frozen_string_literal: true

module Jekyll
  class IncrementalSite < Site
    # Initialize a new Site for incremental builds.
    #
    # config - A Hash containing site configuration details.
    def initialize(_config)
      super

      require_relative "incremental_regenerator"
      @regenerator = IncrementalRegenerator.new(self)
    end

    # Read, process, and write this Site to output.
    #
    # Returns nothing.
    def process
      return profiler.profile_process if config["profile"]

      reset
      read
      generate
      render
      cleanup
      write
    end

    # Reset Site details.
    #
    # Returns nothing
    def reset
      super
      @regenerator.clear_cache
      nil
    end

    # Write static files, pages, and posts.
    #
    # Returns nothing.
    def write
      Jekyll::Commands::Doctor.conflicting_urls(self)
      each_site_file do |item|
        item.write(dest) if regenerator.regenerate?(item)
      end
      regenerator.write_metadata
      Jekyll::Hooks.trigger :site, :post_write, self
      nil
    end

    private

    def render_docs(payload)
      collections.each_value do |collection|
        collection.docs.each do |document|
          render_regenerated(document, payload)
        end
      end
    end

    def render_pages(payload)
      pages.each do |page|
        render_regenerated(page, payload)
      end
    end

    def render_regenerated(document, payload)
      return unless regenerator.regenerate?(document)

      document.renderer.payload = payload
      document.output = document.renderer.run
      document.trigger_hooks(:post_render)
    end
  end
end
