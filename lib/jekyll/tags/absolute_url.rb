module Jekyll
  class AbsoluteUrl < Liquid::Tag

    def initialize(_, markup, _)
      @markup = markup.to_s.strip
    end

    def render(context)
      site = context.registers[:site]
      File.join(site.url, site.baseurl, @markup).strip
    end

  end
end

Liquid::Template.register_tag(Jekyll::AbsoluteUrl, 'absolute_url')
