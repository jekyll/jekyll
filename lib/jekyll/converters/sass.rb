module Jekyll

  class SassConverter < Converter
    safe true

    def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      Sass::Engine.new(sanitize(content),
                       :syntax => :scss,
                       :style => :compressed,
                       :load_paths => [base]
                      ).render
    rescue
      content
    end

    private

    # Malform SASS control directives @if, @for, @each, @while.
    # Hacking with @f@foror will not work -> @f-or
    #
    # Temporary solution, I believe (see https://github.com/nex3/sass/issues/123)
    def sanitize(content)
      content.gsub(/@((if)|(for)|(each)|(while))/, '-')
    end
  end

end