# Usage: Organize your photo files like this:
#
# your_gallery_name/index.html
# your_gallery_name/img/YYYYMMDD-photo1.jpg
# your_gallery_name/img/YYYYMMDD-photo2.jpg
# your_gallery_name/img/YYYYMMDD-photo3.jpg
# your_gallery_name/img/YYYYMMDD-etc.jpg
#
# Your index.html should contain at least this, for the simplest gallery:
#
#   {% gallery name:your_gallery_name %}
#   <img src="{{ image }}" />
#   {% endgallery %}
#
# The important point here is that 'your_gallery_name' in the liquid tag
# matches the directory name that contains the index.html file and the 'img'
# directory.
#
# If the directory containing your images is called something other than
# 'img' and you're too lazy to rename it, you can optionally add the dir
# attribute to the liquid tag to specify the name of the folder. Eg:
#
#   {% gallery name:your_gallery_name dir:your_photo_dir %}
#   <img src="{{ image }}" />
#   {% endgallery %}
#
# If you want to create a grid layout for your images, you can
# combine the 'cycle' liquid tag to achieve that like this:
#
#   <table><tr>
#   {% gallery name:your_gallery_name %}
#   <td><img src="{{ image }}" /></td>
#   {% cycle '', '', '', '</tr><tr>' %}
#   {% endgallery %}
#   </tr></table>
#
# That starts a new row after every fourth image.


module Jekyll
  class GalleryTag < Liquid::Block
    
    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/
    
    def initialize(tag_name, markup, tokens)
      @name = 'image'
      @attributes = {}
      
      # Parse parameters
      if markup =~ Syntax
        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new("Bad options given to 'gallery' plugin.")
      end
      
      if @attributes['name'].nil?
        raise SyntaxError.new("You did not specify the name of your gallery.")
      end
      
      @attributes['dir'] ||= 'img'
      
      super
    end
    
    def render(context)
      context.registers[:gallery] ||= Hash.new(0)
      
      # Find files ending in '.jpg' and sort them reverse-lexically. This means
      # that files whose names begin with YYYYMMDD are sorted newest first.
      images = Dir.glob(File.join(@attributes['name'],
        @attributes['dir'], '*.jpg')).sort {|x,y| y <=> x }
      length = images.length
      result = []
      
      context.stack do
        images.each_with_index do |img, index|
          # Strip first dir off image name. This turns 'gallery/img/foo.jpg'
          # into just 'img/foo.jpg', because this plugin is intended to be
          # used in 'gallery/index.html', giving you nice relative links to
          # the image files.
          context[@name] = img.sub(/^[^\/]+\//, '')
          context['forloop'] = {
            'name' => @name,
            'length' => length,
            'index' => index + 1,
            'index0' => index,
            'rindex' => length - index,
            'rindex0' => length - index - 1,
            'first' => (index == 0),
            'last' => (index == length - 1) 
          }
          
          result << render_all(@nodelist, context)
        end
      end
      result
    end
  end
end

Liquid::Template.register_tag('gallery', Jekyll::GalleryTag)

