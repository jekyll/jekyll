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
      # preventing infinite loops while parsing (due to possible incorrect
      # using of Sass control directives. We don't want to fully disable control
      # directives as Compass uses it)
      Timeout::timeout(3) do
        Sass::Engine.new(content,
                         :syntax => :scss,
                         :style => :compressed,
                         :load_paths => compass_framework_dirs << base
                        ).render
      end
    rescue Sass::SyntaxError, Timeout::Error
      content
    end

    private

    # Paths to the stylesheets in the Compass gem.
    #
    # Returns Array.
    def compass_framework_dirs
      @compass_dirs ||= begin
        if gemspec = Gem.loaded_specs['compass']
          gemdir = gemspec.full_gem_path
          ['blueprint', 'compass'].map do |lib|
            File.join(gemdir, "frameworks/#{lib}/stylesheets")
          end
        else
          []
        end
      end
    end
  end

end