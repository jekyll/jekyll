module Jekyll::Tags
  class AbsoluteUrl < Liquid::Tag
    include Jekyll::LiquidExtensions

    def initialize(_, markup, _)
      @markup = markup.to_s.strip
    end

    def render(context)
      config = context.registers[:site].config
      File.join(*[
        config['url'],
        config['baseurl'],
        lookup_variable(context, @markup)
      ].map(&:to_s)).strip
    end
  end
end

Liquid::Template.register_tag('absolute_url', Jekyll::Tags::AbsoluteUrl)
