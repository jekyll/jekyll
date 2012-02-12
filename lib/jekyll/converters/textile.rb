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

      # Shortcut if config doesn't contain RedCloth section
      return RedCloth.new(content).to_html if @config['redcloth'].nil?

      # List of attributes defined on RedCloth
      # (from http://redcloth.rubyforge.org/classes/RedCloth/TextileDoc.html)
      attrs = ['filter_classes', 'filter_html', 'filter_ids', 'filter_styles',
              'hard_breaks', 'lite_mode', 'no_span_caps', 'sanitize_html']

      r = RedCloth.new(content)

      # Set attributes in r if they are NOT nil in the config
      attrs.each do |attr|
        r.instance_variable_set("@#{attr}".to_sym, @config['redcloth'][attr]) unless @config['redcloth'][attr].nil?
      end

      r.to_html
    end
  end

end
