module Jekyll
  module Converters
    class Markdown
      class RedcarpetParser
        def initialize(config)
          require 'redcarpet'
          require 'pygments'
          @config = config
          @redcarpet_extensions = {}
          @config['redcarpet']['extensions'].each { |e| @redcarpet_extensions[e.to_sym] = true }

          @renderer ||= Class.new(Redcarpet::Render::HTML) do
            def block_code(code, lang)
              lang = lang && lang.split.first || "text"
              output = add_code_tags(
                Pygments.highlight(code, :lexer => lang, :options => { :encoding => 'utf-8' }),
                lang
              )
            end

            def add_code_tags(code, lang)
              code = code.sub(/<pre>/,'<pre><code class="' + lang + '">')
              code = code.sub(/<\/pre>/,"</code></pre>")
            end
          end
        rescue LoadError
          STDERR.puts 'You are missing a library required for Markdown. Please run:'
          STDERR.puts '  $ [sudo] gem install redcarpet'
          raise FatalException.new("Missing dependency: redcarpet")
        end

        def convert(content)
          @redcarpet_extensions[:fenced_code_blocks] = !@redcarpet_extensions[:no_fenced_code_blocks]
          @renderer.send :include, Redcarpet::Render::SmartyPants if @redcarpet_extensions[:smart]
          markdown = Redcarpet::Markdown.new(@renderer.new(@redcarpet_extensions), @redcarpet_extensions)
          markdown.render(content)
        end
      end
    end
  end
end
