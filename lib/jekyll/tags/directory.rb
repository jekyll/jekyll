# Title: Dynamic directories for Jekyll
# Author: Tommy Sullivan http://superawesometommy.com, Robert Park http://exolucere.ca
# Description: The directory tag lets you iterate over files at a particular path. If files conform to the standard Jekyll format, YYYY-MM-DD-file-title, then those attributes will be populated on the yielded file object. The `forloop` object maintains [its usual context](http://wiki.shopify.com/UsingLiquid#For_loops).
#
# Syntax:
#
#   {% directory path: path/from/source [reverse] [exclude] %}
#     {{ file.url }}
#     {{ file.name }}
#     {{ file.date }}
#     {{ file.slug }}
#     {{ file.title }}
#   {% enddirectory %}
#
# Options:
#
# - `reverse` - Defaults to 'false', ordering files the same way `ls` does: 0-9A-Za-z.
# - `exclude` - Defaults to '.html$', skips the html files in the specified path.
#
# File Attributes:
# 
# - `url` - The absolute path to the published file
# - `name` - The basename
# - `date` - The date extracted from the filename, otherwise the file's creation time
# - `slug` - The basename with date and extension removed
# - `title` - The titlecase'd slug
#

module Jekyll

  class DirectoryTag < Liquid::Block
    include Convertible

    MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/

    attr_accessor :content, :data

    def initialize(tag_name, markup, tokens)
      attributes = {}

      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end

      @path     = attributes['path']   || '.'
      @exclude  = Regexp.new(attributes['exclude'] || '.html$', Regexp::EXTENDED | Regexp::IGNORECASE)
      @rev      = attributes['reverse'].nil?

      super
    end

    def render(context)
      context.registers[:directory] ||= Hash.new(0)

      source_dir = context.registers[:site].source
      directory_files = File.join(source_dir, @path, "*")

      files = Dir.glob(directory_files).reject{|f| f =~ @exclude }
      files.sort! {|x,y| @rev ? x <=> y : y <=> x }

      length = files.length
      result = []

      context.stack do
        files.each_with_index do |filename, index|
          basename = File.basename(filename)

          filepath  = [@path, basename] - ['.']
          path = filepath.join '/'
          url  = '/' + filepath.join('/')

          m, cats, date, slug, ext = *basename.match(MATCHER)

          if m
            date = Time.parse(date)
            ext = ext
            slug = slug
          else
            date = File.ctime(filename)
            ext = basename[/\.[a-z]+$/, 0]
            slug = basename.sub(ext, '')
          end

          context['file'] = {
            'title' => slug.titleize,
            'date' => date,
            'name' => basename,
            'slug' => slug,
            'url' => url
          }

          context['forloop'] = {
            'name' => 'directory',
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

Liquid::Template.register_tag('directory', Jekyll::DirectoryTag)

