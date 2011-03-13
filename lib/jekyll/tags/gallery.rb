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
          
          url  = ['', @name, @dir, basename] - ['.']
          path = url[-2..-1].join '/'
          html = path.sub /\.#{@fmt}$/, '.html'
          url  = url.join '/'
          
          # This matches '1984-11-27-sluggy-slug.ext', with optional hyphens
          # (so '19841127-slugger.ext' is also valid), and the date is optional.
          m, date, year, month, day, slug, ext = *basename.match(
            /((\d{4})-?(\d\d)-?(\d\d))?-?(.*)(\.#{@fmt})$/)
          
          context['file'] = {
            'htmlpath' => html,
            'title' => slug.titleize,
            'date' => year.nil? ? nil : Time.local(year, month, day),
            'name' => basename,
            'slug' => slug,
            'path' => path,
            'url' => url
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

