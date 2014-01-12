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

    def convert(content)
      Object::Sass.compile(content, :syntax => :sass)
    end
  end
end
