module Jekyll

  class HamlConverter < Converter
    safe true

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      Haml::Engine.new(content, :suppress_eval => true, :ugly => true).render
    rescue
      content
    end
  end

end