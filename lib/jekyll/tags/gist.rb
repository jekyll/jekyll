module Jekyll
  class GistTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<script src=\"http://gist.github.com/{@text}.js\"></script>"
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)