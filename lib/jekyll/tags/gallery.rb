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
#   <img src="{{ file.path }}" />
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
#   {% gallery name:your_gallery_name dir:img format:jpg reverse:no %}
#
# By default, the gallery will be sorted reverse-lexically. If you've named
# your files with the YYYYMMDD prefix, this results in a newest-first sorting.
# If you desire the sort to be the other way around, specify 'reverse:no'.
#
# If you want to create a grid layout for your images, you can use the 'cycle'
# tag to achieve that. This example starts a new row after every fourth image:
#
#   <table><tr>
#   {% gallery name:your_gallery_name %}
#   <td><img title="{{ file.title }}" src="{{ file.path }}" /></td>
#   {% cycle '', '', '', '</tr><tr>' %}
#   {% endgallery %}
#   </tr></table>
#
# This example also introduces the 'file.title' tag. It is simply the filename of
# the image converted from hyphenated-lowercase to Title Case.

class String
  def titleize
    gsub(/[-_]+/, ' ').split(/(\W)/).map(&:capitalize).join
  end
end


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
      
      @name = @attributes['name']
      @dir  = @attributes['dir']    || 'img'
      @fmt  = @attributes['format'] || 'jpg'
      @rev  = @attributes['reverse']
      
      # Strip periods and slashes out of the 'dir' and 'name' arguments
      # so that they can't contain evil things like '../..'
      [@dir, @name].each {|s| s.gsub! /[\.\/]/, ''}
      
      super
    end
    
    def render(context)
      context.registers[:gallery] ||= Hash.new(0)
      
      images = Dir.glob(File.join(@name, @dir, "*.#{@fmt}"))
      images.sort! {|x,y| @rev ? x <=> y : y <=> x }
      length = images.length
      result = []
      
      context.stack do
        images.each_with_index do |filename, index|
          basename = File.basename(filename)
          
          # This matches '1984-11-27-sluggy-slug.ext', with optional hyphens
          # (so '19841127-slugger.ext' is also valid), and the date is optional.
          m, date, year, month, day, slug, ext = *basename.match(
            /((\d{4})-?(\d\d)-?(\d\d))?-?(.*)(\.#{@fmt})$/)
          
          context['file'] = {
            'title' => slug.titleize,
            'date' => year.nil? ? nil : Time.local(year, month, day),
            'name' => basename,
            'slug' => slug,
            'ext' => ext,
            'path' => @dir + '/' + basename,
            'url' => ['', @name, @dir, basename].join('/')
          }
          
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

