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

    def sass_build_configuration_options(overrides)
      (@config["sass"] || {}).deep_merge(overrides).symbolize_keys
    end

    def syntax_type_of_content(content)
      if content.include?(";") || content.include?("{")
        :scss
      else
        :sass
      end
    end

    def sass_dir
      @config["source"]["sass"]["sass_dir"] || "_sass"
    end

    def sass_dir_relative_to_site_source
      File.join(
        @config["source"],
        File.expand_path("/", sass_dir)
      )
    end

    def convert(content)
      syntax  = syntax_type_of_content(content)
      configs = sass_build_configuration_options({
        "syntax" => syntax_type_of_content(content),
        "cache"  => false,
        "filesystem_importer" => NilClass,
        "load_paths" => sass_dir_relative_to_site_source
      })
      ::Sass.compile(content, configs)
    end
  end
end
