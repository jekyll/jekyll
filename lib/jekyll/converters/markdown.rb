module Jekyll

  class MarkdownConverter < Converter
    safe true

    pygments_prefix "\n"
    pygments_suffix "\n"

    def setup
      return if @setup
      # Set the Markdown interpreter (and Maruku self.config, if necessary)
      case @config['markdown']
        when 'rdiscount'
          begin
            require 'rdiscount'

            # Load rdiscount extensions
            @rdiscount_extensions = @config['rdiscount']['extensions'].map { |e| e.to_sym }
          rescue LoadError
            STDERR.puts 'You are missing a library required for Markdown. Please run:'
            STDERR.puts '  $ [sudo] gem install rdiscount'
            raise FatalException.new("Missing dependency: rdiscount")
          end
        when 'maruku'
          begin
            require 'maruku'

            if @config['maruku']['use_divs']
              require 'maruku/ext/div'
              STDERR.puts 'Maruku: Using extended syntax for div elements.'
            end

            if @config['maruku']['use_tex']
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
          rescue LoadError
            STDERR.puts 'You are missing a library required for Markdown. Please run:'
            STDERR.puts '  $ [sudo] gem install maruku'
            raise FatalException.new("Missing dependency: maruku")
          end
        else
          STDERR.puts "Invalid Markdown processor: #{@config['markdown']}"
          STDERR.puts "  Valid options are [ maruku | rdiscount ]"
          raise FatalException.new("Invalid Markdown process: #{@config['markdown']}")
      end
      @setup = true
    end

    def matches(ext)
      ext =~ /(markdown|mkdn?|md)/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      case @config['markdown']
        when 'rdiscount'
          RDiscount.new(content, *@rdiscount_extensions).to_html
        when 'maruku'
          Maruku.new(content).to_html
      end
    end
  end

end
