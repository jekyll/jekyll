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
      "<script src=\"http://gist.github.com/#{@gist}.js\" type=\"text/javascript\"> </script>"
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
