module Jekyll
  class Sass < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.sass$/i
    end

    def output_ext(ext)
      ".css"
    end

    def sass_build_configuration_options(overrides)
      (@config["sass"] || {}).deep_merge(overrides)
    end

    def convert(content)
      ::Sass.compile(content, sass_build_configuration_options({"syntax" => :sass}))
    end
  end
end
