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
    split(/[\W_]+/).map(&:capitalize).join ' '
  end
end


module Jekyll
  class GalleryTag < Liquid::Block
    include Convertible
    attr_accessor :content, :data
    
    def initialize(tag_name, markup, tokens)
      attributes = {}
      
      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end
      
      @name = attributes['name']   || '.'
      @dir  = attributes['dir']    || 'img'
      @fmt  = attributes['format'] || 'jpg'
      @rev  = attributes['reverse'].nil?
      
      # Prevent template data from doing evil.
      [@name, @dir, @fmt].each do |s|
        s.delete! '/[]{}*?'
        s.squeeze! '.'
      end
      
      super
    end
    
    def render(context)
      context.registers[:gallery] ||= Hash.new(0)
      
      files = Dir.glob(File.join(@name, @dir, "*.#{@fmt}"))
      files.sort! {|x,y| @rev ? y <=> x : x <=> y }
      length = files.length
      result = []
      
      context.stack do
        files.each_with_index do |filename, index|
          basename = File.basename(filename)
          
          url = ['', @name, @dir, basename] - ['.']
          
          # This matches '1984-11-27-sluggy-slug.ext', with optional hyphens
          # (so '19841127-slugger.ext' is also valid), and the date is optional.
          m, date, year, month, day, slug, ext = *basename.match(
            /((\d{4})-?(\d\d)-?(\d\d))?-?(.*)(\.#{@fmt})$/)
          
          context['file'] = {
            'title' => slug.titleize,
            'date' => year.nil? ? nil : Time.local(year, month, day),
            'name' => basename,
            'slug' => slug,
            'path' => url[-2..-1].join('/'),
            'url' => url.join('/')
          }
          
          # Obviously images don't contain YAML but this bit is included
          # on the off chance that somebody is using this tag for other files
          # that do have YAML Front Matter. This is a harmless nop on images.
          self.read_yaml(File.join(@name, @dir), basename)
          context['file'].merge! self.data
          
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

