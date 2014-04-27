module Jekyll::Tags
  class AbsoluteUrl < Liquid::Tag
    include Jekyll::LiquidExtensions

    def initialize(_, markup, _)
      @markup = markup.to_s.strip
    end

    def render(context)
      site = context.registers[:site]
      File.join(site.url, site.baseurl, lookup_variable(context, @markup)).strip
    end
  end
end

Liquid::Template.register_tag('absolute_url', Jekyll::Tags::AbsoluteUrl)
