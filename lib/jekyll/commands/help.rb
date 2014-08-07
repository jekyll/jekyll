module Jekyll
  module Commands
    class Help < Command
      class << self

        def init_with_program(prog)
          prog.command(:help) do |c|
            c.syntax 'help <command>'
            c.description 'Show the help for'

            c.action do |args, _|
              if args.empty?
                puts prog
              else
                puts prog.commands[args.first.to_sym]
              end
            end
          end
        end

        def usage_message(prog, cmd)
          Jekyll.logger.error "Error:", "No command specified."
          Jekyll.logger.warn  "Usage:", cmd.syntax
          Jekyll.logger.info  "Valid commands:", prog.commands.keys.join(", ")
        end

      end
    end
  end
end
