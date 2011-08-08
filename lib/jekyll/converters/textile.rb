module Jekyll

  class TextileConverter < Converter
    safe true

    pygments_prefix '<notextile>'
    pygments_suffix '</notextile>'

    def setup
      return if @setup
      require 'redcloth'
      @setup = true
    rescue LoadError
      STDERR.puts 'You are missing a library required for Textile. Please run:'
      STDERR.puts '  $ [sudo] gem install RedCloth'
      raise FatalException.new("Missing dependency: RedCloth")
    end

    def matches(ext)
      rgx = '(' + @config['textile_ext'].gsub(',','|') +')'
      ext =~ Regexp.new(rgx, Regexp::IGNORECASE)
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      RedCloth.new(content).to_html
    end
  end

end
