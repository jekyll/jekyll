module Jekyll
  module Commands
    class Help < Command
      class << self

        def init_with_program(prog)
          prog.command(:help) do |c|
            c.syntax 'help [subcommand]'
            c.description 'Show the help message, optionally for a given subcommand.'

            c.action do |args, _|
              if args.empty?
                puts prog
              else
                puts prog.commands[args.first.to_sym]
              end
            end
          end
        end

      end
    end
  end
end
