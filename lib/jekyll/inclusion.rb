# frozen_string_literal: true

module Jekyll
  class Inclusion
    attr_reader :name, :path, :relative_path

    def initialize(site, base, name)
      @site = site
      @name = name
      @path = PathManager.join(base, name)
      @relative_path = compute_relative_path
    end

    def template
      @template ||= site.liquid_renderer.file(relative_path).parse(content)
    end

    def content
      @content ||= File.read(path, **site.file_read_opts)
    end

    def inspect
      "#{self.class} #{@relative_path.inspect}"
    end
    alias_method :to_s, :inspect

    private

    attr_reader :site

    def dir_path
      if site.theme && path.start_with?(site.theme.includes_path)
        PathManager.join site.theme.basename, "_includes"
      else
        site.config["includes_dir"]
      end
    end

    def compute_relative_path
      case path
      when site.theme && %r!#{site.theme.includes_path}/(?<rel_path>.*)!o
        PathManager.join dir_path, Regexp.last_match[:rel_path]
      when %r!#{site.in_source_dir(site.config["includes_dir"], "/")}(?<rel_path>.*)!o
        PathManager.join dir_path, Regexp.last_match[:rel_path]
      else
        path.sub(site.in_source_dir("/"), "")
      end
    end
  end
end
