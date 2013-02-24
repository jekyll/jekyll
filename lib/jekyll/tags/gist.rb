# Gist Liquid Tag
#
# Example:
#    {% gist 1234567 %}

module Jekyll
  class GistTag < Liquid::Tag
    def initialize(tag_name, gist, tokens)
      super
      @gist = gist.strip
    end

    def render(context)
      "<script src=\"https://gist.github.com/#{@gist}.js\"> </script>"
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
