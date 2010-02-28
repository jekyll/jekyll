module Jekyll

  class TextileConverter < Converter
    pygments_prefix '<notextile>'
    pygments_suffix '</notextile>'

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
