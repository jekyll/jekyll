module Jekyll
  class Scss < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.scss$/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      ::Sass.compile(content, :syntax => :scss)
    end
  end
end
