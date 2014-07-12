module Jekyll
  module Converters
    class Markdown
      class RedcarpetParser
        module ConfigHighlighter
          def initialize(renderer, options)
            super(renderer)
            @options = options
          end
        end

        module WithPygments
          include ConfigHighlighter
          def block_code(code, lang)
            lang = lang && lang.split.first || "text"
            Highlighter.render_pygments(code, lang, @options)
          end
        end

        module WithoutHighlighting
          include ConfigHighlighter
          def block_code(code, lang)
            lang = lang && lang.split.first || "text"
            Highlighter.render_codehighlighter(code, lang)
          end
        end

        module WithRouge
          include ConfigHighlighter
          def block_code(code, lang)
            Highlighter.render_rouge(code, lang, @options)
          end

          protected
          def rouge_formatter(opts = {})
            Rouge::Formatters::HTML.new(opts.merge(wrap: false))
          end
        end


        def initialize(config)
          require 'redcarpet'
          @config = config
          @redcarpet_extensions = {}
          @config['redcarpet']['extensions'].each { |e| @redcarpet_extensions[e.to_sym] = true }
          @options = Highlighter.get_config(@config, {})

          @renderer ||= case @config['highlighter']
                        when 'pygments'
                          Class.new(Redcarpet::Render::HTML) do
                            include WithPygments
                          end
                        when 'rouge'
                          Class.new(Redcarpet::Render::HTML) do
                            begin
                              require 'rouge'
                              require 'rouge/plugins/redcarpet'
                            rescue LoadError => e
                              Jekyll.logger.error "You are missing the 'rouge' gem. Please run:"
                              Jekyll.logger.error " $ [sudo] gem install rouge"
                              Jekyll.logger.error "Or add 'rouge' to your Gemfile."
                              raise FatalException.new("Missing dependency: rouge")
                            end

                            if Rouge.version < '1.3.0'
                              abort "Please install Rouge 1.3.0 or greater and try running Jekyll again."
                            end

                            include Rouge::Plugins::Redcarpet
                            include WithRouge
                          end
                        else
                          Class.new(Redcarpet::Render::HTML) do
                            include WithoutHighlighting
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
          markdown = Redcarpet::Markdown.new(@renderer.new(@redcarpet_extensions, @options), @redcarpet_extensions)
          markdown.render(content)
        end
      end
    end
  end
end
