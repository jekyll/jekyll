module Jekyll

  require 'org-ruby'
  class OrgConverter < Converter
    safe true

    priority :low

    def matches(ext)
      ext =~ /org$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      Orgmode::Parser.new(content).to_html
    end
  end

end
