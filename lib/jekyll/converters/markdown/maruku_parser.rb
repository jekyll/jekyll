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

          # Switch off MathML output
          if @config['maruku']['use_math_ml']
            Jekyll.logger.info "Maruku:", "Using LaTeX extension. Embedding MathML in output."
            enable_math_ml
          else
            Jekyll.logger.info "Maruku:", "Using LaTeX extension. Images in `#{@config['maruku']['png_dir']}`."
            disable_math_ml
            setup_math_png
          end
        end

        def enable_math_ml
          MaRuKu::Globals[:html_math_output_mathml] = true
          MaRuKu::Globals[:html_math_engine] = @config['maruku']['math_ml_engine']
        end

        def disable_math_ml
          MaRuKu::Globals[:html_math_output_mathml] = false
          MaRuKu::Globals[:html_math_engine] = 'none'
        end

        # Turn on math to PNG support with blahtex
        # Resulting PNGs stored in `images/latex`
        def setup_math_png
          MaRuKu::Globals[:html_math_output_png] = true
          %w[engine dir url].each do |opt|
            MaRuKu::Globals["html_png_#{opt}".to_sym] = @config['maruku']["png_#{opt}"]
          end
        end

        def print_errors_and_fail
          print @errors.join
          raise MaRuKu::Exception, "MaRuKu encountered problem(s) while converting your markup."
        end

        def convert(content)
          converted = Maruku.new(content, :error_stream => @errors).to_html
          print_errors_and_fail unless @errors.empty?
          converted
        end
      end
    end
  end
end
