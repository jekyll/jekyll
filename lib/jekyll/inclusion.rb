# frozen_string_literal: true

module Jekyll
  class Inclusion
    attr_reader :site, :name, :path
    private :site

    def initialize(site, base, name)
      @site = site
      @name = name
      @path = PathManager.join(base, name)
    end

    def render(context)
      @template ||= site.liquid_renderer.file(path).parse(content)
      @template.render!(context)
    rescue Liquid::Error => e
      e.template_name  = path
      e.markup_context = "included " if e.markup_context.nil?
      raise e
    end

    def content
      @content ||= File.read(path, **site.file_read_opts)
    end

    def inspect
      "#{self.class} #{path.inspect}"
    end
    alias_method :to_s, :inspect
  end
end
