module Jekyll
  module Commando
    class Command
      attr_reader :name
      attr_reader :description
      attr_reader :syntax
      attr_accessor :options
      attr_accessor :commands
      attr_accessor :actions
      attr_reader :map
      attr_accessor :parent

      def initialize(name, parent = nil)
        @name = name
        @options = []
        @commands =  {}
        @actions = []
        @map = {}
        @parent = parent
      end

      def syntax(syntax)
        @syntax = syntax
      end

      def description(desc)
        @description = desc
      end

      def option(sym, *options)
        @options << options
        @map[options[0]] = sym
      end

      def command(cmd_name)
        cmd = Command.new(cmd_name, self)
        yield cmd
        @commands[cmd_name] = cmd
      end

      def alias(cmd_name)
        @parent.commands[cmd_name] = self
      end

      def action(&block)
        @actions << block
      end

      def go(argv, opts, config)
        process_options(opts, config)

        if argv[0] && cmd = commands[argv[0].to_sym]
          puts "Found #{cmd.name}"
          argv.shift
          cmd.go(argv, opts, config)
        else
          puts "No additional command found, time to exec"
          self
        end
      end

      def process_options(opts, config)
        options.each do |o|
          opts.on(*o) do |x|
            config[map[o[0]]] = x
          end
        end
      end

      def ident
        "<Command name=#{name}>"
      end

      def inspect
        msg = ''
        msg += "Command #{name}\n"
        options.each { |o| msg += "  " + o.inspect + "\n"}
        msg += "\n"
        commands.each { |k, v| msg += commands[k].inspect }
        msg
      end
    end
  end
end
