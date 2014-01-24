module Jekyll
  class Sass < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.s(a|c)ss$/i
    end

    def output_ext(ext)
      ".css"
    end

    def jekyll_sass_configuration
      @config["sass"] || {}
    end

    def sass_build_configuration_options(overrides)
      jekyll_sass_configuration.deep_merge(overrides).symbolize_keys
    end

    def syntax_type_of_content(content)
      if content.include?(";") || content.include?("{")
        :scss
      else
        :sass
      end
    end

    def sass_dir
      return "_sass" if jekyll_sass_configuration["sass_dir"].to_s.empty?
      jekyll_sass_configuration["sass_dir"]
    end

    def sass_dir_relative_to_site_source
      File.join(
        @config["source"],
        File.expand_path(sass_dir, "/") # FIXME: Not windows-compatible
      )
    end

    def allow_caching?
      !@config["safe"]
    end

    def sass_configs(content = "")
      sass_build_configuration_options({
        "syntax" => syntax_type_of_content(content),
        "cache"  => allow_caching?,
        "load_paths" => [sass_dir_relative_to_site_source]
      })
    end

    def convert(content)
      ::Sass.compile(content, sass_configs(content))
    end
  end
end
