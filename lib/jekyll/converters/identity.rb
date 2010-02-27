module Jekyll

  class IdentityConverter

    def initialize(config = {})

    end

    def content_type
      nil
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
