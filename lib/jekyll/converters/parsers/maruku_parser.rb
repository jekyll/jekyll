module Jekyll
  module Converters
    class Markdown
      class MarukuParser
        def initialize(config)
          require 'maruku'
          @config = config
          if @config['maruku']['use_divs']
            load_divs_library
          end
          if @config['maruku']['use_tex']
            load_blahtext_library
          end
        rescue LoadError
          STDERR.puts 'You are missing a library required for Markdown. Please run:'
          STDERR.puts '  $ [sudo] gem install maruku'
          raise FatalException.new("Missing dependency: maruku")
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
      end
    end
  end
end
