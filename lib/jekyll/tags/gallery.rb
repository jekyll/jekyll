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
# The important point here is that 'your_gallery_name' matches the directory
# name that contains both the index.html file and the 'img' directory.
#
# The gallery plugin takes a few options to customize itself to your setup.
# 'dir:img' and 'format:jpg' are defaults, so you only need to include those
# if your images are in a different subfolder than 'img' and your files are
# named something other than '.jpg'. 'name' is the only mandatory setting.
#
#   {% gallery name:your_gallery_name dir:img format:jpg %}
#
# If you want to create a grid layout for your images, you can use the 'cycle'
# tag to achieve that. This example starts a new row after every fourth image:
#
#   <table><tr>
#   {% gallery name:your_gallery_name %}
#   <td><img title="{{ title }}" src="{{ image }}" /></td>
#   {% cycle '', '', '', '</tr><tr>' %}
#   {% endgallery %}
#   </tr></table>
#
# This example also introduces the 'title' tag. It is simply the filename of
# the image converted from hyphenated-lowercase to Title Case.


module Jekyll
  class GalleryTag < Liquid::Block
    
    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/
    
    def initialize(tag_name, markup, tokens)
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
        raise ArgumentError.new("You did not specify the name of your gallery.")
      end
      
      @attributes['dir']    ||= 'img'
      @attributes['format'] ||= 'jpg'
      
      @name = @attributes['name']
      @dir  = @attributes['dir']
      @fmt  = @attributes['format']
      
      super
    end
    
    def render(context)
      context.registers[:gallery] ||= Hash.new(0)
      
      # Find files ending in '.jpg' and sort them reverse-lexically. You can
      # achieve newest-first sorting by beginning your filenames with YYYYMMDD
      images = Dir.glob(File.join(@name, @dir, "*.#{@fmt}")).sort {|x,y| y <=> x }
      length = images.length
      result = []
      
      context.stack do
        images.each_with_index do |img, index|
          # Convert hyphens and underscores to spaces, then Title Case the filename,
          # after stripping off the dirname and file extension.
          context['title'] = File.basename(img).chomp(".#{@fmt}").split(
            /[-_]/).map {|word| word.capitalize }.join(' ').sub(/^\d+\s/, '')
          
          # Provide relative links instead of absolute ones.
          context['image'] = img.sub(/^[^\/]+\//, '')
          context['forloop'] = {
            'name' => 'gallery',
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

