module Jekyll
  module Commando
    class Command
      attr_reader :name
      attr_reader :syntax
      attr_accessor :options
      attr_accessor :commands

      def initialize(name)
        @name = name
        @options = [ ]
        @commands =  { }
      end

      def syntax(syntax)
        @syntax = syntax
      end

      def option(*options)
        @options << options
      end

      def command(cmd_name)
        cmd = Command.new(cmd_name)
        yield cmd
        @commands[cmd_name] = cmd
      end

      def go(argv, opts, config)
        process_options(opts, config)

        if cmd = commands[argv[0].to_sym]
          puts "Found #{cmd.name}"
          argv.shift
          cmd.go(argv, opts, config)
        else
          puts "No additional command found, time to exec"

        end
      end

      def process_options(opts, config)
        options.each do |o|
          opts.on(*o) do |x|
            config[o[0]] = x
          end
        end
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