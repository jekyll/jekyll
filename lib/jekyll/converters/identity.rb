module Jekyll
  class IdentityConverter < Converter
    priority :lowest

    def initialize(config = {})

    end

    def matches(ext)
      true
    end

    def output_ext(ext)
      ext
    end

    def convert(content)
      content
    end

  end
end
