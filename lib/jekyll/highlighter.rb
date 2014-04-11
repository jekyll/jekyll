module Jekyll
  class Highlighter
    #supported libraries
    LIBS=['pygments','rouge']
    
    #valid options
    OPTS=['linenos','linenostart']	
	
    def initialize(lib)		
      @lib = if LIBS.include?(lib)
        require lib
        lib
      else
        'simple'
      end
    end
  	
    def render(code, lexer="", opts={})
      opts = opts.select { |k,v| OPTS.include?(k) }
      add_code_tags( send("render_#{@lib}".to_sym, code.to_s.strip, lexer,opts), lexer )
    end
  	
    private
    
    def render_pygments(code, lexer, opts)
        opts[:encoding] = 'utf-8'
        opts['linenos'] &&= 'inline'

        highlighted_code = Pygments.highlight(code, :lexer => lexer, :options => opts)

        if highlighted_code.nil?
          Jekyll.logger.error "There was an error highlighting your code:"
          puts
          Jekyll.logger.error code
          puts
          Jekyll.logger.error "While attempting to convert the above code, Pygments.rb returned an unacceptable value."
          Jekyll.logger.error "This is usually a timeout problem solved by running `jekyll build` again."
          raise ArgumentError.new("Pygments.rb returned an unacceptable value when attempting to highlight some code.")
        end

        return highlighted_code
    end
    
    def render_rouge(code, lexer, opts)
        lexer = Rouge::Lexer.find_fancy(lexer, code) || Rouge::Lexers::PlainText     
        formatter = Rouge::Formatters::HTML.new(line_numbers: opts.has_key?('linenos'), wrap: false)
        highlighted_code = "<div class=\"highlight\"><pre>#{formatter.format(lexer.lex(code))}</pre></div>"

        return highlighted_code
    end
    
    def render_simple(code, lexer, opts)
      require 'cgi'
      "<div><pre>#{CGI::escapeHTML(code.strip)}</pre></div>"
    end
  	
    def add_code_tags(code, lang)
      # Add nested <code> tags to code blocks
      code.sub!(/<pre>\n*/,'<pre><code class="' + lang.to_s.gsub("+", "-") + '">')
      code.sub(/\n*<\/pre>/,"</code></pre>")
    end  	
  end
end