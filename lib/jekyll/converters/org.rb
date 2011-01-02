module Jekyll

  class OrgConverter < Converter
    safe true

    pygments_prefix "\n"
    pygments_suffix "\n"

    def setup
      return if @setup
      require 'org-ruby'
      @setup = true
    rescue LoadError
      STDERR.puts 'You are missing a library required for Textile. Please run:'
      STDERR.puts '  $ [sudo] gem install org-ruby'
      raise FatalException.new("Missing dependency: org-ruby")
    end

    def matches(ext)
      ext =~ /org/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      Orgmode::Parser.new(content).to_html
    end
  end

end
