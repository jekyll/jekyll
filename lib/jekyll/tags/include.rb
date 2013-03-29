module Jekyll
  module Tags
    class IncludeTag < Liquid::Tag
      def initialize(tag_name, file, tokens)
        super
        @file = file.strip
      end

      def render(context)
        @site = context.registers[:site]
        includes_dir = File.join(@site.source, '_includes')

        if File.symlink?(includes_dir)
          return "Includes directory '#{includes_dir}' cannot be a symlink"
        end

        if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
          return "Include file '#{@file}' contains invalid characters or sequences"
        end

        Dir.chdir(includes_dir) do
          choices = Dir['**/*'].reject { |x| File.symlink?(x) }
          if choices.include?(@file)

            source = File.read(@file)            
            source = convert_source(source)            
            partial = Liquid::Template.parse(source)

            context.stack do
              partial.render(context)
            end
          else
            "Included file '#{@file}' not found in _includes directory"
          end
        end
      end

      # Converts the passed text using the first available converter that 
      # matches its extension
      #
      # source - the source text to convert
      #
      # Returns the converted text
      def convert_source(source)
        extension = File.extname(@file)
        converter = @site.converters.find{ |c| c.matches(extension) }

        unless converter.is_a?(Jekyll::Converters::Identity)
          encoder = Jekyll::LiquidEncoder.new(source)
          source = converter.convert(encoder.encoded_content)
          source = encoder.decode(source)
        end
        puts "Reached end" if $debug
        source
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::Tags::IncludeTag)
