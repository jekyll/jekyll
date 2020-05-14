# frozen_string_literal: true

module Jekyll
  class Inclusion
    attr_reader :name, :path

    def initialize(site, base, name)
      @site = site
      @name = name
      @path = PathManager.join(base, name)
    end

    def render(context)
      @template ||= site.liquid_renderer.file(relative_path).parse(content)
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
      "#{self.class} #{relative_path.inspect}"
    end
    alias_method :to_s, :inspect

    private

    attr_reader :site

    # rubocop:disable Metrics/AbcSize
    def relative_path
      @relative_path ||= begin
        case path
        when site.theme && %r!#{site.theme.includes_path}/(?<rel_path>.*)!o
          dir_path = PathManager.join(site.theme.basename, "_includes")
          PathManager.join(dir_path, Regexp.last_match[:rel_path])
        when %r!#{site.in_source_dir(site.config["includes_dir"], "/")}(?<rel_path>.*)!o
          PathManager.join(site.config["includes_dir"], Regexp.last_match[:rel_path])
        else
          path.sub(site.in_source_dir("/"), "")
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
