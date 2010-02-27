module Jekyll
  class TextileConverter < Converter

    def initialize(config = {})

    end

    def matches(ext)
      ext =~ /textile/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      RedCloth.new(content).to_html
    end

  end
end
