module Jekyll
  module Converters
    class Markdown
      class MarukuParser
        def initialize(config)
          require 'maruku'
          @config = config
          @errors = []
          load_divs_library if @config['maruku']['use_divs']
          load_blahtext_library if @config['maruku']['use_tex']

          # allow fenced code blocks (new in Maruku 0.7.0)
          MaRuKu::Globals[:fenced_code_blocks] = !!@config['maruku']['fenced_code_blocks']

        rescue LoadError
          STDERR.puts 'You are missing a library required for Markdown. Please run:'
          STDERR.puts '  $ [sudo] gem install maruku'
          raise Errors::FatalException.new("Missing dependency: maruku")
        end

        def load_divs_library
          require 'maruku/ext/div'
          STDERR.puts 'Maruku: Using extended syntax for div elements.'
        end

        def load_blahtext_library
          require 'maruku/ext/math'
          STDERR.puts "Maruku: Using LaTeX extension. Images in `#{@config['maruku']['png_dir']}`."

          # Switch off MathML output
          MaRuKu::Globals[:html_math_output_mathml] = false
          MaRuKu::Globals[:html_math_engine] = 'none'

          # Turn on math to PNG support with blahtex
          # Resulting PNGs stored in `images/latex`
          MaRuKu::Globals[:html_math_output_png] = true
          MaRuKu::Globals[:html_png_engine] =  @config['maruku']['png_engine']
          MaRuKu::Globals[:html_png_dir] = @config['maruku']['png_dir']
          MaRuKu::Globals[:html_png_url] = @config['maruku']['png_url']
        end

        def print_errors_and_fail
          print @errors.join
          raise MaRuKu::Exception, "MaRuKu encountered problem(s) while converting your markup."
        end

        def convert(content)
          converted = Maruku.new(content, :error_stream => @errors).to_html.strip
          print_errors_and_fail unless @errors.empty?
          converted
        end
      end
    end
  end
end
