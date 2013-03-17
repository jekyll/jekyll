# Gist Liquid Tag
#
# Example:
#    {% gist 1234567 %}
#    {% gist 1234567 file.rb %}

module Jekyll
  class GistTag < Liquid::Tag
    def render(context)
      if tag_contents = @markup.strip.match(/\A(\d+) ?(\S*)\z/)
        gist_id, filename = tag_contents[1].strip, tag_contents[2].strip
        gist_script_tag(gist_id, filename)
      else
        "Error parsing gist id"
      end
    end

    private

    def gist_script_tag(gist_id, filename=nil)
      if filename.empty?
        "<script src=\"https://gist.github.com/#{gist_id}.js\"> </script>"
      else
        "<script src=\"https://gist.github.com/#{gist_id}.js?file=#{filename}\"> </script>"
      end
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
